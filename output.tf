#DNS of LoadBalancer
output "lb_dns_name" {
  description = "DNS of Load balancer"
  value       = aws_lb.tf-poc.dns_name
}