variable zone {
  type    = string
  default = "ru-central1-b"
  description = "Zone"
}
variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the private key used for ssh access"
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