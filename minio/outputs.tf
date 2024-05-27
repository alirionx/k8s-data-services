
data "kubernetes_resources" "minio_service" {
  depends_on = [kubernetes_manifest.minio_service]
  api_version    = "v1"
  kind           = "Service"
  namespace      = var.service_namespace
  field_selector = "metadata.name=minio-${var.service_id}"
}

output "service_enpoint_info" {
  value = {
    internal_ip: data.kubernetes_resources.minio_service.objects[0].spec.clusterIP,
    api_port: data.kubernetes_resources.minio_service.objects[0].spec.ports[0].port,
    console_port: data.kubernetes_resources.minio_service.objects[0].spec.ports[1].port,
    node_port_api: var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.minio_service.objects[0].spec.ports[0].nodePort : "",
    node_port_console: var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.minio_service.objects[0].spec.ports[1].nodePort : "",
    internal_dns: "minio-${var.service_id}.${var.service_namespace}",
    external_ip: var.service_endpoint_type == "LoadBalancer" ? data.kubernetes_resources.minio_service.objects[0].status.loadBalancer.ingress[0].ip: ""
  }
}