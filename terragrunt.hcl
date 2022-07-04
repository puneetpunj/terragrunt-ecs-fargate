locals {
  environment_config     = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
  environment            = local.environment_config.locals.environment
  backend_bucket_name    = local.environment_config.locals.backend_bucket_name
  backend_dynamodb_table = local.environment_config.locals.backend_dynamodb_table
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = local.backend_bucket_name

    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = local.backend_dynamodb_table
  }
}
