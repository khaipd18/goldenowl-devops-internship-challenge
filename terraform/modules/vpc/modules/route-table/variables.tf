variable "var_vpc" {
  description = "The ID of the VPC to which the route table will be associated"
  type        = string
}

variable "var_igw" {
  description = "The ID of the Internet Gateway"
  type        = string
}

variable "var_nat_gw" {
  description = "The ID of the NAT Gateway"
  type        = string
}

variable "var_local_cidr_block" {
  description = "The CIDR block for local traffic within the VPC"
  type        = string
}
