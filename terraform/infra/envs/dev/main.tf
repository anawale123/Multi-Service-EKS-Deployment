module "networking" {
  source = "../../../modules/networking"
  ssm_sg        =  module.bastion_host.ssm_sg
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
  
  vpc_id      = module.networking.vpc_id
  private_subnet = module.networking.private_subnet
  environment   = var.environment
  vpc_endpoints_sg = module.networking.vpc_endpoints_sg
}

module "bastion_host" {
  source = "../../../modules/bastion_host"
  vpc_id        = module.networking.vpc_id
  private_subnet = module.networking.private_subnet
  vpc_endpoints_sg = module.networking.vpc_endpoints_sg
  environment   = var.environment
}

variable "environment" {
  type = string
  default = "dev"
}