
resource "kubernetes_manifest" "rabbitmq_statefulset" {
  depends_on = [ ]
  manifest = yamldecode (
    templatefile( "./templates/rabbitmq-statefulset.yaml", {
      service_id = var.service_id
      service_namespace = var.service_namespace
      service_username = var.service_username
      service_password = var.service_password
      container_image = var.container_image
      datastore_size = var.datastore_size
    })
  )
  computed_fields = [
    "metadata.annotations",
    "metadata.labels",
  ]
  wait {
    fields = {
      "status.readyReplicas" = 1
    }
  }
  timeouts {
    create = "3m"
    update = "3m"
    delete = "1m"
  }
}


resource "kubernetes_manifest" "rabbitmq_service" {
  depends_on = [ kubernetes_manifest.rabbitmq_statefulset ]
  manifest = yamldecode (
    templatefile( "./templates/rabbitmq-service.yaml", {
      service_id = var.service_id
      service_namespace = var.service_namespace
      service_endpoint_type = var.service_endpoint_type
    })
  )
  computed_fields = [
    "metadata.annotations",
    "metadata.labels",
    "spec.sessionAffinityConfig.clientIP.timeoutSeconds",
    "spec.ports[0].nodePort",
    "spec.externalTrafficPolicy",
  ]
  wait {
    fields = {
      "status.loadBalancer.ingress[0].ip" = "^(\\d+(\\.|$)){4}"
    }
  }
  timeouts {
    create = "10m"
    update = "10m"
    delete = "1m"
  }
}

