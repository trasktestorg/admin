provider "github" {}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
  }
  backend "oci" {
    bucket    = "github-org-terraform-state"
    namespace = "axtwf1hkrwcy"
  }
}
