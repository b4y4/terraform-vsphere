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
  #datacenter_id              = data.vsphere_datacenter.dc.id

  #ovf_deploy {
  #  local_ovf_path       = "Templates/debian9-preconfigured"
  #  disk_provisioning    = "thin"
  #  ip_protocol          = "IPV4"
  #  ip_allocation_policy = "STATIC_MANUAL"
  #}

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  disk {
    label = "disk0"
    size  = 20
  }
}
