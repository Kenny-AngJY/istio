resource "helm_release" "metrics-server" {
  count = 0
  name  = "metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.13.0" # chart version

  set = [
    {
      # If true, allow unauthenticated access to /metrics.
      name  = "metrics.enabled"
      value = false
    }
  ]
}


resource "helm_release" "istio_base" {
  count = var.install_istio_charts ? 1 : 0
  name  = "istio-base"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  version    = "1.28.2" # chart version

  create_namespace = true
}

resource "helm_release" "istiod" {
  count = var.install_istio_charts ? 1 : 0
  name  = "istiod"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  version    = "1.28.2" # chart version
  depends_on = [helm_release.istio_base[0]]
}