provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_vpc_network" "default" {
  name = var.network
}

# resource "yandex_vpc_subnet" "default" {
#   v4_cidr_blocks = var.subnet_v4_cidr_blocks
#   zone           = var.zone
#   network_id     = yandex_vpc_network.default.id
# }

#2

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = var.zone
  network_id     = yandex_vpc_network.default.id
  # route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_compute_instance" "vm-0" {
  name = "nat-instance"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    ip_address = "192.168.10.254"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }

}

# resource "yandex_vpc_gateway" "nat_gateway" {
#   name = "gateway"
#   shared_egress_gateway {}
# }

# resource "yandex_vpc_route_table" "rt" {
#   name       = "route-table"
#   network_id = yandex_vpc_network.default.id

#   static_route {
#     destination_prefix = "0.0.0.0/0"
#     next_hop_address   = "192.168.10.254"
#     gateway_id         = yandex_vpc_gateway.nat_gateway.id
#   }
# }

# data "yandex_compute_image" "ubuntu-20-04" {
#   family = "ubuntu-2004-lts"
# }

# resource "yandex_compute_instance" "vm-1" {
#   name = "terraform1"

#   resources {
#     cores  = 2
#     memory = 2
#   }

#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu-20-04.id
#     }
#   }

#   network_interface {
#     subnet_id = yandex_vpc_subnet.public.id
#     nat       = true
#   }

#   metadata = {
#     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
#     serial-port-enable = 1
#   }

# }

#3

resource "yandex_vpc_subnet" "private" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.rt-private.id
}

# resource "yandex_vpc_gateway" "private" {
#   name = "gateway"
#   shared_egress_gateway {}
# }

resource "yandex_vpc_route_table" "rt-private" {
  name       = "route-table"
  network_id = yandex_vpc_network.default.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
    # gateway_id         = yandex_vpc_gateway.private.id
  }
}

data "yandex_compute_image" "ubuntu-20-04" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-2" {
  name = "terraform2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-20-04.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = 1
  }

}