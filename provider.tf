provider "github" {
  owner = "trasktestorg"
  app_auth {
    id              = "1344405"
    installation_id = "69012149"
    pem_file        = var.admin_app_private_key
  }
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
  }
  backend "oci" {
    bucket = "trasktestorg"
    namespace = "axtwf1hkrwcy"
  }
}

variable "admin_app_private_key" {
  type        = string
  sensitive   = true
}
