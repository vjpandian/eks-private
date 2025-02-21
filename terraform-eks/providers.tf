terraform {
  backend "s3" {
    bucket = "vijay-tf-state"
    key    = "circleci-staging-eks-us-east-1.tfstate"
    region = "us-east-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.61.0, < 6.0.0"
    }
    circleci = {
      source  = "kelvintaywl/circleci"
      version = "1.0.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }
}

variable "aws_access_key" {
  description = "Access key used to create instances"
}

variable "aws_secret_key" {
  description = "Secret key used to create instances"
}

variable "aws_region" {
  description = "Default AWS Region for EKS Cluster"
  default     = "us-east-1"
}


provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}