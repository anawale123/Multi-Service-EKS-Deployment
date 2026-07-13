resource "aws_security_group" "ssm_sg" {
  name        = "eks-bastion-sg-${var.environment}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "eks-bastion-sg-${var.environment}"
    Environment = var.environment
  }
}