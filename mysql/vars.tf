variable "kube_api_url" {
  type = string
}

variable "kube_token" {
  type = string
}

variable "container_image" {
  type = string
  default = "docker.io/library/mysql:latest"
}

variable "service_id" {
  type = string
  default = "mysql-on-k8s"
}

variable "service_namespace" {
  type = string
  default = "default"
}

variable "service_root_password" {
  type = string
  default = "mysql"
}

variable "service_endpoint_type" {
  type = string
  default = "ClusterIP"
}

variable "datastore_size"{
  type = number
  default = 2
  validation {
    condition = var.datastore_size > 1 && var.datastore_size < 101
    error_message = "datastore size must be between min 2 and max 100"
  }
  description = "Datastore size in GB ( min 2 - max 100 )"
}

