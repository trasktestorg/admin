provider "github" {
  owner = "trasktestorg"
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
