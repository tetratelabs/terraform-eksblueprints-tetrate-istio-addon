# Copyright (c) Tetrate, Inc 2022 All Rights Reserved.

module "base" {
  count             = var.install_base ? 1 : 0
  source            = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v3.5.0"
  manage_via_gitops = var.manage_via_gitops
  helm_config       = local.base_helm_config
  irsa_config       = null
  addon_context     = var.addon_context
}

module "cni" {
  count             = var.install_cni ? 1 : 0
  source            = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v3.5.0"
  manage_via_gitops = var.manage_via_gitops
  helm_config       = local.cni_helm_config
  irsa_config       = null
  addon_context     = var.addon_context

  depends_on = [module.base]
}

module "istiod" {
  count             = var.install_istiod ? 1 : 0
  source            = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v3.5.0"
  manage_via_gitops = var.manage_via_gitops
  helm_config       = local.istiod_helm_config
  irsa_config       = null
  addon_context     = var.addon_context

  depends_on = [module.cni]
}

module "gateway" {
  count             = var.install_gateway ? 1 : 0
  source            = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons/helm-addon?ref=v3.5.0"
  manage_via_gitops = var.manage_via_gitops
  helm_config       = local.gateway_helm_config
  irsa_config       = null
  addon_context     = var.addon_context

  depends_on = [module.istiod]
}
