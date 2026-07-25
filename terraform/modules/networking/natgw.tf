resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_natgateway.id

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.igw]
}


resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "nat-eip-${var.environment}"
    Environment = var.environment
  }
}