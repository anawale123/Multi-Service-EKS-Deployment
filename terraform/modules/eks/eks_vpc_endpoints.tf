resource "aws_vpc_endpoint" "eks" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.eu-west-2.eks"
  vpc_endpoint_type   = "Interface"
  subnet_ids = [var.private_subnet[0]]
  security_group_ids  = [var.vpc_endpoints_sg]
  private_dns_enabled = true

  tags = {
    Name = "eks-interface-endpoint-dev"
  }
}