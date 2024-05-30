terraform {
  backend "consul" {
    address = "my-consul.example.com"
    scheme  = "http"
    path    = "tfstates/my-service"
  }
}
