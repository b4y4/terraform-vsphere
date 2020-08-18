provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-server"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "terraform-server"
        domain    = "vlan123.entcore.org"
      }
      network_interface {
        ipv4_address = "192.168.123.200"
        ipv4_netmask = "24"
      }

      ipv4_gateway    = "192.168.123.254"
      dns_suffix_list = ["vlan123.entcore.org"]
      dns_server_list = ["192.168.13.8", "192.168.13.9"]
    }
  }
  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  disk {
    label = "disk0"
    size  = 20
  }
}
