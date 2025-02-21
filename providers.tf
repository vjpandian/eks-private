terraform {
  backend "s3" {
    bucket = "-tf-state"
    key    = "circleci-staging-eks-us-west-2.tfstate"
    region = "us-east-1"

    assume_role = {
      role_arn = "arn:aws:iam::xxxxxx:role/circleci_aws_role"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 5.61.0"
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

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::xxxxxx:role/circleci_aws_role"
    session_name = "circleci_staging_aws_role"
  }
  region = var.aws_region

  default_tags {
    tags = var.default_tags
  }
}