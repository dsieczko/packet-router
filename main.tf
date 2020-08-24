provider "packet" {
  auth_token = var.auth_token
}

resource "packet_vlan" "private_vlan" {
  facility    = var.facility
  project_id  = var.project_id
  description = "Private Network"
}

resource "random_string" "bgp_password" {
  length      = 18
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}

resource "packet_device" "router" {
  hostname         = var.hostname
  plan             = var.plan
  facilities       = [var.facility]
  operating_system = var.operating_system
  billing_cycle    = var.billing_cycle
  project_id       = var.project_id
  ipxe_script_url  = var.ipxe_script_url
  always_pxe       = var.always_pxe
}

resource "packet_device_network_type" "router" {
  device_id = packet_device.router.id
  type = "hybrid"
}

resource "packet_port_vlan_attachment" "router_vlan_attach" {
  device_id = packet_device.router.id
  port_name = "eth1"
  vlan_vnid = packet_vlan.private_vlan.vxlan
  depends_on = [packet_device_network_type.router]
}

data "template_file" "vyos_config" {
  template = file("templates/vyos_config.conf")
  vars = {
    bgp_local_asn                 = var.bgp_local_asn
    bgp_neighbor_asn              = var.bgp_neighbor_asn
    bgp_password                  = random_string.bgp_password.result
    hostname                      = var.hostname
    neighbor_short_name           = var.neighbor_short_name
    private_net_cidr              = var.private_net_cidr
    private_net_dhcp_start_ip     = cidrhost(var.private_net_cidr, 2)
    private_net_dhcp_stop_ip      = cidrhost(var.private_net_cidr, -2)
    private_net_gateway_ip_cidr   = format("%s/%s", cidrhost(var.private_net_cidr, 1), split("/", var.private_net_cidr)[1])
    private_net_gateway_ip        = cidrhost(var.private_net_cidr, 2)
    public_dns_1_ip               = var.public_dns_1_ip
    public_dns_2_ip               = var.public_dns_2_ip
    router_ipv6_gateway_ip        = packet_device.router.network.1.gateway
    router_ipv6_ip_cidr           = format("%s/%s", packet_device.router.network.1.address, packet_device.router.network.1.cidr)
    router_private_cidr           = format("%s/%s", cidrhost(format("%s/%s", packet_device.router.network.2.address, packet_device.router.network.2.cidr), 0), packet_device.router.network.2.cidr)
    router_private_gateway_ip     = packet_device.router.network.2.gateway
    router_private_ip_cidr        = format("%s/%s", packet_device.router.network.2.address, packet_device.router.network.2.cidr)
    router_public_gateway_ip      = packet_device.router.network.0.gateway
    router_public_ip_cidr         = format("%s/%s", packet_device.router.network.0.address, packet_device.router.network.0.cidr)
    router_public_ip              = packet_device.router.network.0.address
    gre_peer_outer_public_ipaddr  = var.gre_peer_outer_public_ipaddr
    gre_peer_inner_private_ipaddr = var.gre_peer_inner_private_ipaddr
    gre_my_inner_private_ipaddr   = var.gre_my_inner_private_ipaddr
  }
}

resource "local_file" "vyos_config" {
  content         = data.template_file.vyos_config.rendered
  filename        = "${path.module}/vyos.conf"
  file_permission = "0644"
}