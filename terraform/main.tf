provider "yandex" {
  zone = var.zone
}

resource "yandex_vpc_network" "default" {
  name = var.network
}

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = var.subnet_v4_cidr_blocks
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.default.id
}

