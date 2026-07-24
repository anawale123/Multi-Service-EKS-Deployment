# SECRETS READ POLICY
resource "aws_iam_policy" "secrets_read" {
  name = "secrets-read-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = [
        "arn:aws:secretsmanager:eu-west-2:679930074435:secret:db_cred-xSueHj"
      ]
    }]
  })
}

# SQS POLICY
resource "aws_iam_policy" "worker_sqs" {
  name = "worker-sqs-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ChangeMessageVisibility"
      ]
      Resource = [
        "arn:aws:sqs:eu-west-2:703844615264:sqs-queue",
        "arn:aws:sqs:eu-west-2:703844615264:sqs-queue-dlq"
      ]
    }]
  })
}

# API IRSA
resource "aws_iam_role" "api_irsa" {
  name = "api-irsa-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.cluster_oicd.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.cluster_oicd.url, "https://", "")}:sub" = "system:serviceaccount:url-shortener:api-sa"
        }
      }
    }]
  })

  tags = {
    Name        = "api-irsa-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "api_secrets" {
  role       = aws_iam_role.api_irsa.name
  policy_arn = aws_iam_policy.secrets_read.arn
}

# WORKER IRSA
resource "aws_iam_role" "worker_irsa" {
  name = "worker-irsa-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.cluster_oicd.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.cluster_oicd.url, "https://", "")}:sub" = "system:serviceaccount:url-shortener:worker-sa"
        }
      }
    }]
  })

  tags = {
    Name        = "worker-irsa-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "worker_secrets" {
  role       = aws_iam_role.worker_irsa.name
  policy_arn = aws_iam_policy.secrets_read.arn
}

resource "aws_iam_role_policy_attachment" "worker_sqs" {
  role       = aws_iam_role.worker_irsa.name
  policy_arn = aws_iam_policy.worker_sqs.arn
}

# DASHBOARD IRSA
resource "aws_iam_role" "dashboard_irsa" {
  name = "dashboard-irsa-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.cluster_oicd.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.cluster_oicd.url, "https://", "")}:sub" = "system:serviceaccount:url-shortener:dashboard-sa"
        }
      }
    }]
  })

  tags = {
    Name        = "dashboard-irsa-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "dashboard_secrets" {
  role       = aws_iam_role.dashboard_irsa.name
  policy_arn = aws_iam_policy.secrets_read.arn
}