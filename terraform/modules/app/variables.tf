variable "db_address" {
  description = "Database IP"
  default     = "127.0.0.1"
}

variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}

variable zone {
  description = "Zone"

  # Значение по умолчанию
  default = "europe-west1-b"
}

variable "node_count" {
  default = "1"
}
