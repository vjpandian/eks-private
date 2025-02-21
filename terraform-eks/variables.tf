##########################################################################
################ Variable Definitions ####################################
##########################################################################


variable "eks_managed_node_group_defaults" {
  type    = list(string)
  default = ["t3a.medium"]
}

variable "vpc_id" {
  description = "Default VPC for terraform"
  default     = "vpc-0e3cac62b25e9feb9"
}


variable "ebs_volume_type" {
  type    = string
  default = "gp3"
}

variable "disk_size" {
  type    = number
  default = 250
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
  default     = ["subnet-084482dafe3be89f5", "subnet-0b2627cd831f33f66", "subnet-0d432122e35eaaf3d"]
}

variable "default_subnet" {
  type        = string
  description = "Default Subnet ID for EC2"
  default     = "subnet-084482dafe3be89f5"
}


variable "default_tags" {
  type = map(string)
  default = {
    "enviornment" = "circleci-staging"
    "vendor"      = "circleci"
    "cluster"     = "circleci-staging"
  }
}