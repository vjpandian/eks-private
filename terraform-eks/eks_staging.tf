locals {
  cluster_basename                = "vijay-staging-eks"
  kubernetes_version              = "1.31"
  ng_support_default_min_size     = 0
  ng_support_default_desired_size = 4
  ng_support_default_max_size     = 5
  circleci_staging_eks_admin_role = "fieldeng-awesomeci-role"

}



module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = local.cluster_basename
  cluster_version = local.kubernetes_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnets
  control_plane_subnet_ids = var.subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = var.eks_managed_node_group_defaults
  }

  eks_managed_node_groups = {
    circleci-staging-ng = {

      min_size = local.ng_support_default_min_size
      max_size = local.ng_support_default_max_size
      #desired_size         = var.ng_desired_size
      force_update_version = true
      # The role created by the Terraform module already has the cluster-specific attributes
      # Setting this to false ensures that the name_prefix conforms to the limits set by AWS
      iam_role_use_name_prefix = false
      # Add additional EBS CSI Driver Policy to the Nodegroup IAM role
      # https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEBSCSIDriverPolicy.html
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
      #ami_type       = "AL2_ARM_64"
      instance_types = var.eks_managed_node_group_defaults
      #ami_id               = data.aws_ami.eks_default.image_id
      #update_config = {
      #  max_unavailable_percentage = 33 # or set `max_unavailable`
      #}
      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = false

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = var.disk_size
            volume_type = var.ebs_volume_type
            iops        = 3000
            throughput  = 150
            encrypted   = false
            #kms_key_id            = module.ebs_kms_key.key_arn
            delete_on_termination = true
          }
        }
      }

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 10
        instance_metadata_tags      = "enabled"
      }
    }

    circleci-staging-ng-2 = {

      min_size = local.ng_support_default_min_size
      max_size = local.ng_support_default_max_size
      #desired_size         = var.ng_desired_size
      force_update_version = true
      # The role created by the Terraform module already has the cluster-specific attributes
      # Setting this to false ensures that the name_prefix conforms to the limits set by AWS
      iam_role_use_name_prefix = false
      # Add additional EBS CSI Driver Policy to the Nodegroup IAM role
      # https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEBSCSIDriverPolicy.html
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
      #ami_type       = "AL2_ARM_64"
      instance_types = var.eks_managed_node_group_defaults
      #ami_id               = data.aws_ami.eks_default.image_id
      #update_config = {
      #  max_unavailable_percentage = 33 # or set `max_unavailable`
      #}
      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = false

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = var.disk_size
            volume_type = var.ebs_volume_type
            iops        = 3000
            throughput  = 150
            encrypted   = false
            #kms_key_id            = module.ebs_kms_key.key_arn
            delete_on_termination = true
          }
        }
      }
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 10
        instance_metadata_tags      = "enabled"
      }
    }
  }




  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {

    fieldeng_aws_ci_role_access = {
      # This is for providing the role access to run kubectl commands via CI pipelines
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.circleci_staging_eks_admin_role}"
      policy_associations = {
        admin_policy = {
          #### https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
        namespace_policy = {
          #### https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type       = "namespace"
            namespaces = ["default", "kube-system", "*"]
          }
        }
      }
    }

  }
  tags = var.default_tags
}