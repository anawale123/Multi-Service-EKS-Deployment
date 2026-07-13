resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.eu-west-2.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids = [var.private_subnet[0]]
  security_group_ids  = [var.vpc_endpoints_sg]
  private_dns_enabled = true

  tags = {
    Name        = "ssm-endpoint-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.eu-west-2.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids = [var.private_subnet[0]]
  security_group_ids  = [var.vpc_endpoints_sg]
  private_dns_enabled = true

  tags = {
    Name        = "ssmmessages-endpoint-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.eu-west-2.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids = [var.private_subnet[0]]
  security_group_ids  = [var.vpc_endpoints_sg]
  private_dns_enabled = true

  tags = {
    Name        = "ec2messages-endpoint-${var.environment}"
    Environment = var.environment
  }
}
