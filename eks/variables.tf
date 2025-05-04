variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string 
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster will be created"
  type        = list(string)
}

#Node groups are the worker nodes that run your applications. EKS manages the lifecycle of these nodes, including scaling and updating them.
# You can create multiple node groups within a single EKS cluster, each with different instance types and scaling configurations.
#Sample:
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
# In this example, we have two node groups: "frontend" and "backend".
# "frontend" has two instance types (t3.large) and uses on-demand capacity, while "backend" uses spot instances with a single instance type (m5.large).
# Each node group has its own scaling configuration, allowing you to specify the desired, maximum, and minimum number of nodes for each group.
# This flexibility allows you to optimize costs and performance based on your application's needs.
# The node groups can be created with different instance types and scaling configurations, allowing for flexibility in resource allocation.
# The scaling configuration specifies the desired, maximum, and minimum number of nodes for each group.

variable "node_groups" {
  description = "values for the node groups"
  type = map(object({
    instance_types   = list(string)
    capacity_type   = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}