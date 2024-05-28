data "kubernetes_resources" "rabbitmq_service" {
  depends_on = [kubernetes_manifest.rabbitmq_service]
  api_version    = "v1"
  kind           = "Service"
  namespace      = var.service_namespace
  field_selector = "metadata.name=rabbitmq-${var.service_id}"
}

output "service_internal_ip" {
  depends_on = [data.kubernetes_resources.rabbitmq_service]
  value = data.kubernetes_resources.rabbitmq_service.objects[0].spec.clusterIP
}
output "service_port_api" {
  depends_on = [data.kubernetes_resources.rabbitmq_service]
  value = data.kubernetes_resources.rabbitmq_service.objects[0].spec.ports[0].port
}
output "service_port_console" {
  depends_on = [data.kubernetes_resources.rabbitmq_service]
  value = data.kubernetes_resources.rabbitmq_service.objects[0].spec.ports[1].port
}
output "service_node_port_api" {
  depends_on = [data.kubernetes_resources.rabbitmq_service]
  value = var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.rabbitmq_service.objects[0].spec.ports[0].nodePort : ""
}
output "service_node_port_console" {
  depends_on = [data.kubernetes_resources.rabbitmq_service]
  value = var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.rabbitmq_service.objects[0].spec.ports[1].nodePort : ""
}
output "service_internal_dns" {
  depends_on = [data.kubernetes_resources.rabbitmq_service]
  value = "rabbitmq-${var.service_id}.${var.service_namespace}"
}
output "service_external_ip" {
  depends_on = [data.kubernetes_resources.rabbitmq_service]
  value = var.service_endpoint_type == "LoadBalancer" ? data.kubernetes_resources.rabbitmq_service.objects[0].status.loadBalancer.ingress[0].ip: ""
}


output "service_enpoint_info_json" {
  depends_on = [data.kubernetes_resources.rabbitmq_service]
  value = jsonencode( 
    {
      internal_ip: data.kubernetes_resources.rabbitmq_service.objects[0].spec.clusterIP,
      port_api: data.kubernetes_resources.rabbitmq_service.objects[0].spec.ports[0].port,
      port_console: data.kubernetes_resources.rabbitmq_service.objects[0].spec.ports[1].port,
      node_port_api: var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.rabbitmq_service.objects[0].spec.ports[0].nodePort : "",
      node_port_console: var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.rabbitmq_service.objects[0].spec.ports[1].nodePort : "",
      internal_dns: "rabbitmq-${var.service_id}.${var.service_namespace}",
      external_ip: var.service_endpoint_type == "LoadBalancer" ? data.kubernetes_resources.rabbitmq_service.objects[0].status.loadBalancer.ingress[0].ip: ""
    }
  )
}