resource "helm_release" "metrics_server" {
  name = "metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.13.0" # chart version

  set = [
    {
      name  = "metrics.enabled"
      value = false
    }
  ]

  # depends_on = [aws_eks_fargate_profile.kube-system]
}


resource "helm_release" "istio_base" {
  name = "istio-base"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  version    = "1.28.0" # chart version

  create_namespace = true
}

resource "helm_release" "istiod" {
  name = "istiod"

  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  version    = "1.28.0" # chart version

}