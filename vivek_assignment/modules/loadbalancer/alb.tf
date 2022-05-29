resource "aws_lb" "loadbalancer-module" {
  name               = var.alb_name
  internal           = var.alb_type
  load_balancer_type = var.lb_type
  security_groups    = var.alb_sg
  subnets            = var.alb_subnet
  enable_deletion_protection = false

  tags = { environ = var.environ  }
}
