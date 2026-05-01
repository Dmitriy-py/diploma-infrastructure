resource "yandex_lb_target_group" "k8s_workers" {
  name      = "k8s-workers-group"

  target {
    subnet_id = data.terraform_remote_state.network.outputs.subnet_b_id
    address   = yandex_compute_instance.worker[0].network_interface.0.ip_address
  }

  target {
    subnet_id = data.terraform_remote_state.network.outputs.subnet_d_id
    address   = yandex_compute_instance.worker[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "k8s_lb" {
  name = "k8s-network-lb"

  listener {
    name = "http-listener"
    port = 80
    target_port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s_workers.id
    healthcheck {
      name = "tcp-check"
      tcp_options {
        port = 80
      }
    }
  }
}

