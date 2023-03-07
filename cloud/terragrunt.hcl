locals {
  global = yamldecode(file("../cloud/common.yaml"))
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"

    contents = <<EOF
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "${local.global.region}"
}
EOF
  }
  config = {
    bucket = "${get_env("TG_BUCKET_PREFIX", "")}-infrastructure"

    key = "terraform/${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.global.region}"
    encrypt        = true

  }
}
