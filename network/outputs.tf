output "subnet_a_id" {
  value = yandex_vpc_subnet.subnet-a.id
}

output "subnet_b_id" {
  value = yandex_vpc_subnet.subnet-b.id
}

output "subnet_d_id" {
  value = yandex_vpc_subnet.subnet-d.id
}

output "registry_id" {
  value = yandex_container_registry.registry.id
}