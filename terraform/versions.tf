terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }

  backend "kubernetes" {
    secret_suffix = "neoledge-vms"
    namespace     = "neoledge"
  }
}

provider "kubernetes" {}
