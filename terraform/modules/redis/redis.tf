resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-group-${var.environment}"
  subnet_ids = var.private_redis
  tags = { 
    Name = "redis_subnet_group" 
  }
}

data "aws_secretsmanager_secret" "redis_auth" {
  name = "redis_auth_token"
}

data "aws_secretsmanager_secret_version" "redis_auth" {
  secret_id = data.aws_secretsmanager_secret.redis_auth.id
}

locals {
  redis_creds = jsondecode(data.aws_secretsmanager_secret_version.redis_auth.secret_string)
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "shortener-redis-${var.environment}"
  description                 = "Redis for URL shortener"
  engine                      = "redis"
  engine_version               = "7.0"
  node_type                   = "cache.t3.micro"
  num_cache_clusters          = 1
  port                         = 6379
  subnet_group_name           = aws_elasticache_subnet_group.redis.name
  security_group_ids          = [var.redis_sg]

  transit_encryption_enabled = true
  auth_token                  = local.redis_creds.auth_token

  tags = {
    Name = "redis shortener"
  }
}