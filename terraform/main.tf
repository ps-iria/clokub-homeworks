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

# resource "yandex_vpc_subnet" "public" {
#   v4_cidr_blocks = ["172.31.32.0/19"]
#   zone           = var.zone
#   network_id     = yandex_vpc_network.default.id
#   route_table_id = yandex_vpc_route_table.rt.id
# }

# resource "yandex_vpc_gateway" "nat_gateway" {
#   name = "gateway"
#   shared_egress_gateway {}
# }

# resource "yandex_vpc_route_table" "rt" {
#   name       = "route-table"
#   network_id = yandex_vpc_network.default.id

#   static_route {
#     destination_prefix = "0.0.0.0/0"
#     next_hop_address   = "172.31.32.1"
#     # gateway_id         = yandex_vpc_gateway.nat_gateway.id
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
  v4_cidr_blocks = ["172.31.96.0/19"]
  zone           = var.zone
  network_id     = yandex_vpc_network.default.id
  route_table_id = yandex_vpc_route_table.rt-private.id
}

resource "yandex_vpc_gateway" "private" {
  name = "gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt-private" {
  name       = "route-table"
  network_id = yandex_vpc_network.default.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "172.31.32.1"
    # gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}