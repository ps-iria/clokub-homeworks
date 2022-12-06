provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

locals {
  vm_cores = {
    stage = 1
    prod = 2
  }
  vm_memory = {
    stage = 1
    prod = 2
  }
  instance_count = {
    stage = 1
    prod = 2
  }
  instances = {
    stage = 1
    prod = 2
  }
}

resource "yandex_vpc_network" "hw15" {
  name       = "hw15"
  zone = "ru-central1-b"
}

resource "yandex_compute_instance" "vm" {
  name = "vm-from-custom-image"

  count = local.instance_count[terraform.workspace]

  lifecycle {
    create_before_destroy = true
  }
  resources {
    cores         = "2"
    memory        = "1"
    core_fraction = "20"
  }
  network_interface {
    subnet_id = var.folder_id
    nat       = "true"
  }
  boot_disk {
    initialize_params {
      image_id = "fd8gu48shgedqb1ubago"
      type = "network-hdd"
      size = "5"
    }
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

