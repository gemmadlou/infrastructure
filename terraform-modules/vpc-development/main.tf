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

  azs             = [
    "${var.aws_region}a", 
    "${var.aws_region}b", 
    "${var.aws_region}c"
  ]

  private_subnets = [
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 0)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 1)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 2)}",
  ]
  
  public_subnets  = [
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 3)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 4)}",
    "${cidrsubnet(var.cidr_base, var.cidr_newbits, 5)}",
  ]

  enable_ipv6 = true

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "public-subnet"
  }

  public_subnet_tags_per_az = {
    "${var.aws_region}a" = {
      "name" = "${var.aws_region}a"
      "availability-zone" = "${var.aws_region}a"
    }
  }

  tags = local.tags

  vpc_tags = {
    Name = "${local.name}"
  }
}