resource "aws_iam_role" "cluster_iam" {
  name = "eks-cluster-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "eks-cluster-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_iam.name
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.k8_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster_oicd" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.k8_cluster.identity[0].oidc[0].issuer
}


resource "aws_eks_access_entry" "admin" {
  cluster_name      = aws_eks_cluster.k8_cluster.name
  principal_arn     = "arn:aws:iam::679930074435:user/eks_admin"
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.k8_cluster.name
  principal_arn = "arn:aws:iam::679930074435:user/eks_admin"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}