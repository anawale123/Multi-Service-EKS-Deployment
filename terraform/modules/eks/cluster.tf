resource "aws_eks_cluster" "k8_cluster" {
  name     = "url-shortener-${var.environment}"
  role_arn = aws_iam_role.cluster_iam.arn
  version  = "1.32"

  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    subnet_ids              = var.private_subnet
    security_group_ids = [aws_security_group.cluster_sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]

  tags = {
    Name        = "url-shortener-${var.environment}"
    Environment = var.environment
  }
}
