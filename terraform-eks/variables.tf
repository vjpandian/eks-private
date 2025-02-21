##########################################################################
################ Variable Definitions ####################################
##########################################################################


variable "eks_managed_node_group_defaults" {
  type    = list(string)
  default = ["t3a.medium"]
}

variable "vpc_id" {
  description = "Default VPC for terraform"
  default     = "vpc-084774308279094a4"
}


variable "ebs_volume_type" {
  type    = string
  default = "gp3"
}

variable "disk_size" {
  type    = number
  default = 250
}


variable "eks_managed_node_group_defaults" {
  type    = list(string)
  default = ["t3a.medium"]
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
  default     = ["subnet-016896490ed3c0022", "subnet-044555533b43f13f9", "subnet-08c9c502ed8fcbb0a", "subnet-0eb9dfc9c93c5dff2"]
}

variable "default_subnet" {
  type        = string
  description = "Default Subnet ID for EC2"
  default     = "subnet-016896490ed3c0022"
}


variable "default_tags" {
  type = map(string)
  default = {
    "enviornment"         = "circleci-staging"
    "vendor"              = "circleci"
    "cluster"             = "circleci-staging"
  }
}