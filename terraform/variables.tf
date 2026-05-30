variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "ap-southeast-1"
}
#vpc configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.18.0.0/16"
}

variable "az_ids" {
  type        = list(string)
  description = "List of availability zone IDs for subnets"
  default     = ["apse1-az1", "apse1-az2"]
}

#ecr configuration
variable "scan_on_push" {
  description = "Whether to enable image scanning on push"
  type        = bool
  default     = false
}

variable "repository_names" {
  description = "List of ECR repository names"
  type        = set(string)
  default     = ["khaipd18-goldenowl-devops-repo"]
}

variable "force_delete" {
  description = "Whether to force delete the repository even if it contains images"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "allow_push_principals" {
  description = "List of principals allowed to push images to the repository"
  type        = list(string)
  default     = []
}

variable "allow_pull_principals" {
  description = "List of principals allowed to pull images from the repository"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Cluster name for ECS Cluster"
  type        = string
  default     = "goldenowl-devops-cluster"
}

variable "app_port" {
  description = "Port number where the app listens (e.g., 3000)"
  type        = number
  default     = 3000
}

variable "github_repo" {
  description = "The GitHub repository in the format 'owner/repo' that will be allowed to assume the role"
  type        = string
  default     = "khaipd18/goldenowl-devops-internship-challenge"
}
