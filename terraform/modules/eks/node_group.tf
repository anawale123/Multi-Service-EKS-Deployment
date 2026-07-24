  resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.k8_cluster.name
  node_group_name = "url-shortener-nodes-${var.environment}"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.private_subnet
  ami_type        = "AL2_x86_64"

  launch_template {
    id      = aws_launch_template.nodes.id
    version = "$Latest"
  }

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


resource "aws_launch_template" "nodes" {
  name          = "eks-nodes-${var.environment}"
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.nodes_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  tags = {
    Name        = "eks-nodes-${var.environment}"
    Environment = var.environment
  }
}