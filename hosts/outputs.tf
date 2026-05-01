output "master_ip" {
  value = yandex_compute_instance.master.network_interface.0.nat_ip_address
}

output "master_internal_ip" {
  value = yandex_compute_instance.master.network_interface.0.ip_address
}

output "worker_internal_ips" {
  value = yandex_compute_instance.worker[*].network_interface.0.ip_address
}

output "load_balancer_public_ip" {
  value = [for s in yandex_lb_network_load_balancer.k8s_lb.listener : tolist(s.external_address_spec)[0].address][0]
}