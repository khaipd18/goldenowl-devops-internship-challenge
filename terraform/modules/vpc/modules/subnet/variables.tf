# SUBNET VARIABLES
variable "var_vpc_id" {
  description = "The ID of the VPC to which the subnet will be associated"
  type        = string
}

variable "var_vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "var_subnet_az_id" {
  description = "The availability zone ID for the subnet"
  type        = list(string)
}
