resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.k8_cluster.name
  node_group_name = "url-shortener-nodes-${var.environment}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.private_subnet
  instance_types  = ["t3.medium"]
  ami_type        = "AL2_x86_64"
  disk_size       = 20

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 5
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = {
    Name        = "url-shortener-nodes-${var.environment}"
    Environment = var.environment
  }
}