data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    endpoints = { s3 = "https://storage.yandexcloud.net" }
    bucket = "diploma-tfstate-klimovdg"
    region = "ru-central1"
    key    = "terraform.tfstate"

    access_key = var.access_key
    secret_key = var.secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "master" {
  name     = "master"
  hostname = "master"
  platform_id = "standard-v2"
  allow_stopping_for_update = true
  zone     = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = "fd88esinna6s76ta4pvq"
      size     = 20
    }
  }

  network_interface {
    subnet_id = data.terraform_remote_state.network.outputs.subnet_a_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

resource "yandex_compute_instance" "worker" {
  count    = 2
  name     = "worker-${count.index}"
  hostname = "worker-${count.index}"
  platform_id               = "standard-v2"
  allow_stopping_for_update = true
  zone     = count.index == 0 ? "ru-central1-b" : "ru-central1-d"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 100
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd88esinna6s76ta4pvq"
      size     = 20
    }
  }

  network_interface {
    subnet_id = count.index == 0 ? data.terraform_remote_state.network.outputs.subnet_b_id : data.terraform_remote_state.network.outputs.subnet_d_id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}
