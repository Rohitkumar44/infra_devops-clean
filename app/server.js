const http = require("http");

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    return res.end("ok");
  }

  if (req.url === "/") {
    res.writeHead(200, { "Content-Type": "text/plain" });
    return res.end("Hello from the private EC2 API!");
  }

  res.writeHead(404, { "Content-Type": "text/plain" });
  res.end("Not found");
});

server.listen(8080, () => {
  console.log("Server running on port 8080");
});
