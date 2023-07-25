output "network_id" {
  description = "The ID of the network."
  value       = yandex_vpc_network.vpc_network.id
}

output "subnet_ids" {
  description = "The IDs of the subnets."
  value       = {for s in yandex_vpc_subnet.vpc_subnet : s.zone => s.id}
}

output "subnet_zones" {
  description = "The zones of the subnets."
  value       = [for s in var.subnets : s.zone]
}