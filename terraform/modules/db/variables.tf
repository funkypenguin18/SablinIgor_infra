variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db"
}

variable zone {
  description = "Zone"

  # Значение по умолчанию
  default = "europe-west1-b"
}
