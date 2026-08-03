resource "aws_subnet" "public_natgateway" {
  vpc_id     = aws_vpc.vpc_app.id
  cidr_block = var.nategateway_cidr

  tags = {
    Environment = var.environment
  }
}

resource "aws_subnet" "alb_subnet" {
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = var.alb_cidr
  availability_zone = "eu-west-2c"

  tags = {
    Environment                                   = var.environment
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/url-shortener-staging" = "shared"
  }
}

resource "aws_subnet" "alb_subnet_b" {
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = var.alb_cidr_b
  availability_zone = "eu-west-2b"

  tags = {
    Environment                                   = var.environment
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/url-shortener-staging" = "shared"
  }
}