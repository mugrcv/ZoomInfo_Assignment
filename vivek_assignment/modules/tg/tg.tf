resource "aws_lb_target_group" "service1_tg" {
  name        = var.tg_name
  port        = 80
  protocol    = var.protocol_type
  target_type = var.tg_type 
  vpc_id      = var.vpc_id

  tags = { environ = var.environ  }

}
