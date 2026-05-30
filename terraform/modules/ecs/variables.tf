variable "cluster_name" {
  description = "Cluster name cho ECS Cluster"
  type        = string
}

variable "app_image" {
  description = "Docker image URI"
  type        = string
}

variable "app_port" {
  description = "Port number where the app listens (e.g., 3000)"
  type        = number
}

variable "private_subnets_ids" {
  description = "Private Subnet IDs list for ECS Service)"
  type        = list(string)
}
variable "public_subnets_ids" {
  description = "Public Subnet IDs list for ECS Service)"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where ECS Service will be deployed"
  type        = string
}