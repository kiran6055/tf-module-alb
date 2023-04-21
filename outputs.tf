output "dns_name" {
  value = aws_lb.main.dns_name
}

output "listner" {
  value = aws_lb_listener.backend.*.arn[0]
}