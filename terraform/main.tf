provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_vpc_network" "default" {
  name = var.network
}

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = var.subnet_v4_cidr_blocks
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.rt.id
}

# resource "yandex_vpc_gateway" "nat_gateway" {
#   name = "gateway"
#   shared_egress_gateway {}
# }

resource "yandex_vpc_route_table" "rt" {
  name       = "route-table"
  network_id = yandex_vpc_network.default.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "172.16.10.10"
    # gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8gu48shgedqb1ubago"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
