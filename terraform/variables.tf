variable "region" {
  description = "AWS region to deploy into. Availability zones for the new VPC are derived from this region."
  type        = string
  default     = "ap-southeast-1"
}

variable "create_vpc" {
  description = "Choose whether to create a new VPC."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "If create_vpc is false, define your own vpc_id."
  type        = string
  default     = ""

  validation {
    condition     = var.create_vpc || startswith(var.vpc_id, "vpc-")
    error_message = "vpc_id must be set to an existing VPC ID (vpc-...) when create_vpc is false."
  }
}

variable "list_of_subnet_ids" {
  description = "If create_vpc is false, define your own subnet_ids. EKS requires subnets in at least two availability zones."
  type        = list(string)
  default     = []

  validation {
    condition     = var.create_vpc || length(var.list_of_subnet_ids) >= 2
    error_message = "list_of_subnet_ids must contain at least two subnet IDs when create_vpc is false."
  }

  validation {
    condition     = alltrue([for id in var.list_of_subnet_ids : startswith(id, "subnet-")])
    error_message = "Every entry in list_of_subnet_ids must be a subnet ID (subnet-...)."
  }
}

variable "create_kms_key" {
  description = "Controls if a KMS key for cluster encryption should be created."
  type        = bool
  default     = true
}

# variable "kms_key_arn" {
#   type    = string
#   default = "arn:aws:kms:<region>:<account-id>:key/xxx"
# }

variable "use_eks_pod_identity_agent" {
  description = "Install the EKS Pod Identity Agent add-on and use Pod Identity for the VPC CNI role. Defaults to false, which uses IAM Roles for Service Accounts (IRSA)."
  type        = bool
  default     = false

  validation {
    condition     = !(var.use_eks_pod_identity_agent && var.use_fargate_profile)
    error_message = "EKS Pod Identity is not supported on Fargate. Set use_eks_pod_identity_agent = false when use_fargate_profile = true."
  }
}

variable "create_eks_worker_nodes_in_private_subnet" {
  description = "Place worker nodes (and control plane ENIs) in the private subnets of the created VPC. If false, the public subnets are used. Ignored when create_vpc is false."
  type        = bool
  default     = true
}

variable "use_fargate_profile" {
  description = <<EOF
  Defaults to false to use node group.
  If true, creates fargates profiles instead.
  Will force "create_eks_worker_nodes_in_private_subnet" to
  be true if "use_fargate_profile" is true.
  EOF
  type        = bool
  default     = false
}

variable "create_aws_ebs_csi_driver_add_on" {
  description = "Create the aws_ebs_csi_driver add-on for EKS. Ignored when enable_auto_mode is true, as Auto Mode has built-in EBS storage."
  type        = bool
  default     = false
}

variable "create_amazon_cloudwatch_observability_add_on" {
  description = "Create the amazon_cloudwatch_observability add-on for EKS."
  type        = bool
  default     = false
}

variable "install_istio_charts" {
  description = "Install Istio charts on the EKS cluster."
  type        = bool
  default     = false
}

variable "install_istio_gateway" {
  description = "Install Istio gateway on the EKS cluster."
  type        = bool
  default     = false
}

variable "enable_auto_mode" {
  description = "Enable EKS auto mode. This will disable creating EKS managed node groups and the basic add-ons."
  type        = bool
  default     = false
}
