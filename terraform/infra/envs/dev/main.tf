module "networking" {
  source = "../../../modules/networking"
  environment   = var.environment

}

module "sqs" {
  source = "../../../modules/sqs"
   environment   = var.environment
  
}

module "rds" {
  source = "../../../modules/rds"

  vpc_id      = module.networking.vpc_id
  private_rds = module.networking.private_rds
  rds_sg      = module.networking.rds_sg
  environment   = var.environment
}

module "redis" {
  source = "../../../modules/redis"

  vpc_id      = module.networking.vpc_id
  private_redis = module.networking.private_redis
  redis_sg      = module.networking.redis_sg
  environment   = var.environment
}

module "eks" {
  source = "../../../modules/eks"
  
  vpc_id        = module.networking.vpc_id
  private_subnet = module.networking.private_subnet
  environment   = var.environment
  

}


variable "environment" {
  type = string
  default = "dev"
}