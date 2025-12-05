#!/bin/bash
# Update and install dependencies
yum update -y

# Install Node.js
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs git amazon-cloudwatch-agent

# Create application folder
mkdir -p /opt/app
cd /opt/app

# Create server.js
cat <<EOF > server.js
const fs = require("fs");
const http = require("http");

const logStream = fs.createWriteStream("/opt/app/server.log", { flags: "a" });

const server = http.createServer((req, res) => {
  logStream.write(\`[\${new Date().toISOString()}] Request: \${req.url}\n\`);

  if (req.url === "/health") return res.end("ok");
  if (req.url === "/") return res.end("Hello from EC2 with CloudWatch Logs!");

  res.writeHead(404);
  res.end("Not found");
});

server.listen(8080);
console.log("Server running on port 8080");
EOF

# Start Node.js app in background
node server.js &

# Install CloudWatch agent config
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/opt/app/server.log",
            "log_group_name": "/ec2/api",
            "log_stream_name": "{instance_id}-server",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a start \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -m ec2
