include {
  path = find_in_parent_folders()
}

locals {
  terraform_config            = read_terragrunt_config(find_in_parent_folders("terraform_config.hcl"))
  tag                         = local.terraform_config.locals.tag
  environment_specific_config = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
}

terraform {
  source = "git::git@github.com:puneetpunj/terraform-modules.git//modules/vpc?ref=${local.tag}"
}

inputs = {
  aws_region = "ap-southeast-2"
}
