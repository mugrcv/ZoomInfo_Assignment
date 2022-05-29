output "pub_alb_arn" { value = aws_lb.loadbalancer-module.arn }

output "pub_alb_dnsname" { value = aws_lb.loadbalancer-module.dns_name }

output "pub_alb_arn_suffix" { value = aws_lb.loadbalancer-module.arn_suffix }
