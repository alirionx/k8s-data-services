
data "kubernetes_resources" "couchdb_service" {
  depends_on = [kubernetes_manifest.couchdb_service]
  api_version    = "v1"
  kind           = "Service"
  namespace      = var.service_namespace
  field_selector = "metadata.name=couchdb-${var.service_id}"
}


output "service_internal_ip" {
  depends_on = [data.kubernetes_resources.couchdb_service]
  value = data.kubernetes_resources.couchdb_service.objects[0].spec.clusterIP
}
output "service_port" {
  depends_on = [data.kubernetes_resources.couchdb_service]
  value = data.kubernetes_resources.couchdb_service.objects[0].spec.ports[0].port
}
output "service_node_port" {
  depends_on = [data.kubernetes_resources.couchdb_service]
  value = var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.couchdb_service.objects[0].spec.ports[0].nodePort : ""
}
output "service_internal_dns" {
  depends_on = [data.kubernetes_resources.couchdb_service]
  value = "couchdb-${var.service_id}.${var.service_namespace}"
}
output "service_external_ip" {
  depends_on = [data.kubernetes_resources.couchdb_service]
  value = var.service_endpoint_type == "LoadBalancer" ? data.kubernetes_resources.couchdb_service.objects[0].status.loadBalancer.ingress[0].ip: ""
}


output "service_enpoint_info_json" {
  depends_on = [data.kubernetes_resources.couchdb_service]
  value = jsonencode( 
    {
      internal_ip: data.kubernetes_resources.couchdb_service.objects[0].spec.clusterIP,
      port: data.kubernetes_resources.couchdb_service.objects[0].spec.ports[0].port,
      node_port: var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.couchdb_service.objects[0].spec.ports[0].nodePort : "",
      internal_dns: "couchdb-${var.service_id}.${var.service_namespace}",
      external_ip: var.service_endpoint_type == "LoadBalancer" ? data.kubernetes_resources.couchdb_service.objects[0].status.loadBalancer.ingress[0].ip: ""
    }
  )
}