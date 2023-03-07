variable "aws_region" {
    type = string
}

variable "cidr_base" {
    type = string
    description = "eg. 10.0.0.0/16"
}

variable "cidr_newbits" {
    type = number
    description = "eg. 8"
    default = 8
}