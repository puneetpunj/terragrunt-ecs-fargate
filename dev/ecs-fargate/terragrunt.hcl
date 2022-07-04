include {
  path = find_in_parent_folders()
}

locals {
  terraform_config            = read_terragrunt_config(find_in_parent_folders("terraform_config.hcl"))
  tag                         = local.terraform_config.locals.tag
  environment_specific_config = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
}

terraform {
  source = "git::git@github.com:puneetpunj/terraform-modules.git//modules/ecs-fargate?ref=${local.tag}"
}


dependency "network" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id             = { id = "temporary-dummy-id" }
    private_subnet_ids = [{ id = "mocka" }, { id = "mockb" }]
    public_subnet_ids  = [{ id = "mocka" }, { id = "mockb" }]
  }
}

inputs = {
  aws_region         = "ap-southeast-2"
  vpc_id             = dependency.network.outputs.vpc_id.id
  public_subnet_ids  = dependency.network.outputs.public_subnet_ids.*.id
  private_subnet_ids = dependency.network.outputs.private_subnet_ids.*.id

}
