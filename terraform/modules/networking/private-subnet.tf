resource "aws_subnet" "private_subnet_a" {
  
  vpc_id     = aws_vpc.vpc_app.id
  cidr_block = var.private_ecs_cidr_a
  availability_zone = "eu-west-2b"

  tags = {
    Name        = "private-subnet-a-${var.environment}"
    Environment = var.environment
    "kubernetes.io/cluster/url-shortener-dev" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }
}

resource "aws_subnet" "private_subnet_b" {
 
  vpc_id     = aws_vpc.vpc_app.id
  cidr_block = var.private_ecs_cidr_b
  availability_zone = "eu-west-2c"

  tags = {
    Name        = "private-subnet-b-${var.environment}"
    Environment = var.environment
    "kubernetes.io/cluster/url-shortener-dev" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }
}

resource "aws_subnet" "private_rds" {
  vpc_id             = aws_vpc.vpc_app.id
  cidr_block         = var.private_rds_cidr
  availability_zone  = "eu-west-2c"

  tags = {
    Name        = "private-rds-a-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_rds_b" {
  vpc_id             = aws_vpc.vpc_app.id
  cidr_block         = var.private_rds_cidr_b
  availability_zone  = "eu-west-2b"

  tags = {
    Name        = "private-rds-b-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_redis" {
  vpc_id             = aws_vpc.vpc_app.id
  cidr_block         = var.private_redis_cidr
  availability_zone  = "eu-west-2c"

  tags = {
    Name        = "private-redis-a-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_redis_b" {
  vpc_id             = aws_vpc.vpc_app.id
  cidr_block         = var.private_redis_cidr_b
  availability_zone  = "eu-west-2b"

  tags = {
    Name        = "private-redis-b-${var.environment}"
    Environment = var.environment
  }
}
