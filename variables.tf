variable "auth_token" {
  type        = string
  description = "Packet API Key"
}

variable "project_id" {
  type        = string
  description = "The project id to deploy into"
}


variable "gre_tun_ipcidr" {
  type        = string
  description = "Private IP /30 for GRE tunnel"
}

variable "gre_remote_ipaddr" {
  type        = string
  description = "Public IP for the other end of the GRE tunnel." 
}

variable "hostname" {
  type        = string
  default     = "edge-router"
  description = "Hostname for router"
}

variable "facility" {
  type        = string
  default     = "dc13"
  description = "Packet Facility to deploy into"
}

variable "plan" {
  type        = string
  default     = "c3.small.x86"
  description = "Packet device type to deploy"
}

variable "operating_system" {
  type        = string
  description = "The Operating system of the node (This needs to be (custom_ipxe)"
  default     = "custom_ipxe"
}

variable "ipxe_script_url" {
  type        = string
  default     = "http://cdn.vyos.io/ipxe/1.2.5-packet-20200501013409/vyos-ipxe.txt"
  description = "Location of VyOS iPXE script"
}

variable "always_pxe" {
  type        = bool
  default     = false
  description = "Wheather to always boot via iPXE or not."
}

variable "billing_cycle" {
  description = "How the node will be billed (Not usually changed)"
  default     = "hourly"
}

variable "bgp_local_asn" {
  type        = number
  default     = 65000
  description = "Local BGP ASN"
}

variable "bgp_neighbor_asn" {
  type        = number
  default     = 1828
  description = "Neighbor BGP ASN"
}

variable "neighbor_short_name" {
  type        = string
  default     = "Unitas"
  description = "Friendly name of who you are peering with"
}

variable "private_net_cidr" {
  type        = string
  default     = "172.31.254.0/24"
  description = "Private IP Space used for Packet Devices that will be advertized via BGP (/30 or greater)"
}

variable "public_dns_1_ip" {
  type        = string
  default     = "8.8.8.8"
  description = "Public DNS Name Server 1"
}

variable "public_dns_2_ip" {
  type        = string
  default     = "8.8.4.4"
  description = "Public DNS Name Server 2"
}