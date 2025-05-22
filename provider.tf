provider "github" {
  owner = "trasktestorg"
}

terraform {
  required_providers {
    github = {
      version = "~> 6.6.0"
    }
  }
}
