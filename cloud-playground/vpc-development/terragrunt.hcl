include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//terraform-modules/vpc-development"
}

locals {
  global = yamldecode(file(find_in_parent_folders("common.yaml")))
}

inputs = {
  aws_region = local.global.region
  cidr_base = "10.0.16.0/20"
  cidr_newbits = 4
}