module "pub-lb" {
  source     = "../vivek_assignment/modules/loadbalancer/"
  alb_name    = "pub-alb"
  alb_type    = true
  alb_sg      = [aws_security_group.pub-lb-sg.id]
  alb_subnet = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
}

module "pri-lb" {
  source     = "../vivek_assignment/modules/loadbalancer/"
  alb_name    = "pri-alb"
  alb_type    = true
  alb_sg      = [aws_security_group.pub-lb-sg.id]
  alb_subnet = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
}

module "s1-tg" {
  source  = "../vivek_assignment/modules/tg/"
  count   = var.tg_count
  tg_name = "service-${count.index + 1}"
  vpc_id  = aws_vpc.myvpc.id
}


resource "aws_alb_listener" "http-listner" {
  load_balancer_arn = module.pub-lb.pub_alb_arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = module.s1-tg[0].pub-tg-arn
  }
}

resource "aws_alb_listener" "http-private-listner" {
  load_balancer_arn = module.pri-lb.pub_alb_arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = module.s1-tg[1].pub-tg-arn
  }
}
