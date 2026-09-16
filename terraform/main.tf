locals {
  vm_names = [for i in range(1, var.vm_count + 1) : format("%s-%02d", var.vm_prefix, i)]
}

resource "kubernetes_manifest" "vm" {
  for_each = toset(local.vm_names)

  manifest = {
    apiVersion = "kubevirt.io/v1"
    kind       = "VirtualMachine"
    metadata = {
      name      = each.key
      namespace = "neoledge"
      labels = {
        app          = "neo-app"
        "managed-by" = "terraform"
        batch        = var.vm_prefix
      }
    }
    spec = {
      runStrategy  = "Always"
      instancetype = { name = var.vm_size }
      preference   = { inferFromVolume = "rootdisk" }
      dataVolumeTemplates = [{
        metadata = { name = "${each.key}-root" }
        spec = {
          sourceRef = {
            kind      = "DataSource"
            name      = var.vm_os
            namespace = "openshift-virtualization-os-images"
          }
          storage = { resources = { requests = { storage = var.vm_disk } } }
        }
      }]
      template = {
        spec = {
          domain = { devices = {} }
          volumes = [
            { name = "rootdisk", dataVolume = { name = "${each.key}-root" } },
            {
              name = "cloudinit"
              cloudInitNoCloud = {
                userData = <<-EOT
                  #cloud-config
                  hostname: ${each.key}
                  user: neoadmin
                  ssh_authorized_keys:
                    - ${var.ssh_pub_key}
                EOT
              }
            }
          ]
        }
      }
    }
  }

  # Champs complétés par OpenShift Virtualization après création :
  # on les ignore pour éviter des faux écarts dans le plan
  computed_fields = [
    "metadata.labels",
    "metadata.annotations",
    "spec.template.metadata",
    "spec.template.spec.domain",
    "spec.template.spec.architecture",
  ]

  wait {
    fields = {
      "status.ready" = "true"
    }
  }

  timeouts {
    create = "15m"
    update = "10m"
    delete = "10m"
  }
}
