resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  service_name        = var.ecr_api
  vpc_id              = aws_vpc.myvpc.id
  vpc_endpoint_type   = var.ep_type
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id
  security_group_ids  = [aws_security_group.endpoint-sg.id]

  tags = {
    Name = "ecrendpoint"
    environ = var.environ
  }
}


resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  service_name        = var.dkr_api
  vpc_id              = aws_vpc.myvpc.id
  vpc_endpoint_type   = var.ep_type
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id
  security_group_ids  = [aws_security_group.endpoint-sg.id]

  tags = {
    Name = "ecrdkrendpoint"
    environ = var.environ
  }
}


resource "aws_vpc_endpoint" "s3-gateway-endpoint" {
  service_name      = var.s3_api
  vpc_endpoint_type = var.epw_type
  vpc_id            = aws_vpc.myvpc.id
  route_table_ids   = [aws_route_table.private_route.id]


  tags = {
    Name = "s3gwendpoint"
    environ = var.environ
  }
}

resource "aws_vpc_endpoint" "logs-ep" {
  service_name        = var.cp_api
  vpc_id              = aws_vpc.myvpc.id
  private_dns_enabled = true
  vpc_endpoint_type   = var.ep_type
  subnet_ids          = aws_subnet.private_subnet.*.id
  security_group_ids  = [aws_security_group.endpoint-sg.id]


  tags = {
    Name = "cloudwatchendpoint"
    environ = var.environ
  }
}
