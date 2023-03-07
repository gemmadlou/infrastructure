provider "aws" {
  region = "${var.aws_region}"
}

locals {
  name   = "ex-${replace(basename(path.cwd), "_", "-")}"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = "${var.cidr_base}"

  azs                 = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets     = [
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 0)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 1)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 2)}"
    ]
  public_subnets      = [
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 3)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 4)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 5)}",
  ]
  database_subnets    = [
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 6)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 7)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 8)}",
  ]
  intra_subnets       = [
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 9)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 10)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 11)}",
  ]

  private_subnet_names = ["Private Subnet One", "Private Subnet Two"]
  # public_subnet_names omitted to show default name generation for all three subnets
  database_subnet_names    = ["DB Subnet One"]
  intra_subnet_names       = []

  create_database_subnet_group = false

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${local.name}-default" }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${local.name}-default" }

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  tags = local.tags
}