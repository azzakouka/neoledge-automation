terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }

  backend "kubernetes" {
    secret_suffix     = "neoledge-vms"
    namespace         = "neoledge"
    in_cluster_config = true
  }
}

# Sans paramètre : le provider utilise le ServiceAccount du pod
provider "kubernetes" {}
