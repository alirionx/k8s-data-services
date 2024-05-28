provider "kubernetes" {
  host = var.kube_api_url
  token = var.kube_token
  insecure = true
}