terraform {
  backend "s3" {
    bucket = "tfstate"
    endpoints = {
      s3 = "https://your-minio.local/"
    }
    key = "service_name.tfstate"

    access_key="geh"
    secret_key="Heim"

    region                      = "main"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true 
    skip_s3_checksum            = true 
    insecure = true 

    # workspace_key_prefix = ""
    # http_proxy = "http://10.0.2.2:3128"
  }
}
