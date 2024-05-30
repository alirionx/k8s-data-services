terraform {
  backend "kubernetes" {
    secret_suffix = "my-service"
    config_path = "~/.kube/config"
    insecure = true
    namespace = "default"
  }
}