variable zone {
  type    = string
  default = "ru-central1-b"
  description = "Zone"
}
variable public_key_path {
  description = "~/.ssh/id_rsa.pub"
}
variable private_key_path {
  description = "~/.ssh/id_rsa"
}
variable cloud_id {
  description = "cloud id"
}
variable folder_id {
  description = "Folder"
}
variable token {
  description = "Token yc"
}
variable "network" {
  type    = string
  default = "hw15-network"
}
variable "subnet" {
  type    = string
  default = "hw15-subnet"
}
variable "subnet_v4_cidr_blocks" {
  type    = list(string)
  default = ["172.31.0.0/16"]
}
variable "user" {
  type = string
  default = "yc-user"
}
variable "password" {
  type = string
}