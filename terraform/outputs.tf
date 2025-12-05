output "alb_dns" {
  value = aws_lb.alb.dns_name
  description = "The DNS name of the ALB"
}
