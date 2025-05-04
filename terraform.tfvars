# This file contains the variables used in the Terraform configuration which is used to create an EKS cluster and its associated resources.
# Compare this snippet from vpc/main.tf:
vpc_cidr             = "10.16.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidrs  = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
private_subnet_cidrs = ["10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20"]

# EKS RELATED VARIABLES
cluster_version = "1.32"
cluster_name    = "opentelemetry-cluster"

node_groups = {
  worker-nodes = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    scaling_config = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
    }
  }
}

#Could be the below depending on the use case: For critical workloads, you might want to use on-demand instances for better availability and reliability.
# For cost-sensitive workloads, you might want to use spot instances to save costs, but be aware of the potential for interruptions.
#node_groups = {
#  "frontend" = {
#    instance_types = ["t3.large"]
#    capacity_type = "ON_DEMAND"
#    scaling_config = {
#      desired_size = 2
#      max_size     = 5
#      min_size     = 1

#    }
#  }
#  "backend" = {
#    instance_types = ["m5.large"]
#    capacity_type = "SPOT"
#    scaling_config = {
#      desired_size = 3
#      max_size     = 6
#      min_size     = 2
#    }
#  }
#}
