output "alb_security_group_id" {
  description = "Security group ID of the ALB (used to allow traffic into ECS tasks)."
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "ARN of the target group the ECS service registers with."
  value       = aws_lb_target_group.app.arn
}

output "alb_dns_name" {
  description = "Public DNS name of the load balancer."
  value       = aws_lb.main.dns_name
}

output "alb_arn_suffix" {
  description = "ARN suffix of the ALB (used for CloudWatch alarm dimensions)."
  value       = aws_lb.main.arn_suffix
}
