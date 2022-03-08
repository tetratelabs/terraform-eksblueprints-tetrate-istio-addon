# Copyright (c) Tetrate, Inc 2022 All Rights Reserved.

variable "distribution" {
  type        = string
  default     = "TID"
  description = "Istio distribution"
}

variable "distribution_version" {
  type        = string
  default     = ""
  description = "Istio version"
}

variable "install_base" {
  type        = bool
  default     = false
  description = "Install Istio `base` Helm Chart"
}

variable "install_cni" {
  type        = bool
  default     = false
  description = "Install Istio `cni` Helm Chart"
}

variable "install_istiod" {
  type        = bool
  default     = false
  description = "Install Istio `istiod` Helm Chart"
}

variable "install_gateway" {
  type        = bool
  default     = false
  description = "Install Istio `gateway` Helm Chart"
}

variable "base_helm_config" {
  type        = any
  default     = {}
  description = "Istio `base` Helm Chart Configuration"
}

variable "cni_helm_config" {
  type        = any
  default     = {}
  description = "Istio `cni` Helm Chart Configuration"
}

variable "istiod_helm_config" {
  type        = any
  default     = {}
  description = "Istio `istiod` Helm Chart Configuration"
}

variable "gateway_helm_config" {
  type        = any
  default     = {}
  description = "Istio `gateway` Helm Chart Configuration"
}

variable "manage_via_gitops" {
  type        = bool
  default     = false
  description = "Determines if the add-on should be managed via GitOps."
}

variable "addon_context" {
  type = object({
    aws_caller_identity_account_id = string
    aws_caller_identity_arn        = string
    aws_eks_cluster_endpoint       = string
    aws_partition_id               = string
    aws_region_name                = string
    eks_cluster_id                 = string
    eks_oidc_issuer_url            = string
    eks_oidc_provider_arn          = string
    tags                           = map(string)
  })
  description = "Input configuration for the addon"
}
