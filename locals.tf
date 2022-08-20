# Copyright (c) Tetrate, Inc 2022 All Rights Reserved.

locals {
  default_version = coalesce(var.distribution_version, "1.12.9")

  default_helm_config = {
    name                       = "undefined"
    chart                      = "undefined"
    repository                 = "https://istio-release.storage.googleapis.com/charts"
    version                    = local.default_version
    namespace                  = "istio-system"
    timeout                    = "1200"
    create_namespace           = true
    description                = "Istio service mesh"
    lint                       = false
    wait                       = true
    wait_for_jobs              = false
    verify                     = false
    keyring                    = ""
    repository_key_file        = ""
    repository_cert_file       = ""
    repository_ca_file         = ""
    repository_username        = ""
    repository_password        = ""
    disable_webhooks           = false
    reuse_values               = false
    reset_values               = false
    force_update               = false
    recreate_pods              = false
    cleanup_on_fail            = false
    max_history                = 0
    atomic                     = false
    skip_crds                  = false
    render_subchart_notes      = true
    disable_openapi_validation = false
    dependency_update          = false
    replace                    = false
    postrender                 = ""
    set                        = []
    set_sensitive              = []
    values                     = []
  }

  per_distribution_helm_configs = {
    "TID" = local.tetrate_istio_distribution_helm_config
  }

  per_distribution_helm_values = {
    "TID" = local.tetrate_istio_distribution_helm_values
  }

  distribution_helm_config = lookup(local.per_distribution_helm_configs, var.distribution, {})
  distribution_helm_values = lookup(local.per_distribution_helm_values, var.distribution, {})

  cni_helm_values = [yamlencode({
    "istio_cni" : {
      "enabled" : var.install_cni
    }
  })]

  default_base_helm_values    = lookup(local.distribution_helm_values, "base", [])
  default_cni_helm_values     = lookup(local.distribution_helm_values, "cni", [])
  default_istiod_helm_values  = concat(lookup(local.distribution_helm_values, "istiod", []), local.cni_helm_values)
  default_gateway_helm_values = lookup(local.distribution_helm_values, "gateway", [])

  base_helm_config = merge(
    local.default_helm_config,
    local.distribution_helm_config,
    { name = "istio-base", chart = "base" },
    var.base_helm_config,
    { values = concat(local.default_base_helm_values, lookup(var.base_helm_config, "values", [])) }
  )

  cni_helm_config = merge(
    local.default_helm_config,
    local.distribution_helm_config,
    { name = "istio-cni", chart = "cni" },
    var.cni_helm_config,
    { values = concat(local.default_cni_helm_values, lookup(var.cni_helm_config, "values", [])) }
  )

  istiod_helm_config = merge(
    local.default_helm_config,
    local.distribution_helm_config,
    { name = "istio-istiod", chart = "istiod" },
    var.istiod_helm_config,
    { values = concat(local.default_istiod_helm_values, lookup(var.istiod_helm_config, "values", [])) }
  )

  gateway_helm_config = merge(
    local.default_helm_config,
    local.distribution_helm_config,
    { name = "istio-ingressgateway", chart = "gateway" },
    var.gateway_helm_config,
    { values = concat(local.default_gateway_helm_values, lookup(var.gateway_helm_config, "values", [])) }
  )

  argocd_gitops_config = {
    enable = true
  }
}
