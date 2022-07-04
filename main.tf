module "network" {
  source     = "github.com/puneetpunj/terraform-modules/modules/vpc"
  aws_region = var.aws_region
}

module "ecs-fargate" {
  source             = "github.com/puneetpunj/terraform-modules/modules/ecs-fargate"
  aws_region         = var.aws_region
  vpc_id             = module.network.vpc_id.id
  public_subnet_ids  = module.network.public_subnet_ids.*.id
  private_subnet_ids = module.network.private_subnet_ids.*.id
}
