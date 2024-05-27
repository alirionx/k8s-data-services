
data "kubernetes_resources" "couchdb_service" {
  depends_on = [kubernetes_manifest.couchdb_service]
  api_version    = "v1"
  kind           = "Service"
  namespace      = var.service_namespace
  field_selector = "metadata.name=couchdb-${var.service_id}"
}

output "service_enpoint_info" {
  depends_on = [kubernetes_resources.couchdb_service]
  value = {
    internal_ip: data.kubernetes_resources.couchdb_service.objects[0].spec.clusterIP,
    port: data.kubernetes_resources.couchdb_service.objects[0].spec.ports[0].port,
    node_port: var.service_endpoint_type == "NodePort" ? data.kubernetes_resources.couchdb_service.objects[0].spec.ports[0].nodePort : "",
    internal_dns: "couchdb-${var.service_id}.${var.service_namespace}",
    # external_ip: var.service_endpoint_type == "LoadBalancer" ? data.kubernetes_resources.couchdb_service.objects[0].status.loadBalancer.ingress[0].ip: ""
    external_ip: var.service_endpoint_type == "LoadBalancer" ? data.kubernetes_resources.couchdb_service.objects[0].status.loadBalancer: ""
  }
}