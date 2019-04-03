variable input_port {
  description = "Порт для входищих соединений"
}

variable source_tag_name {
  description = "Тэг сети для входящих соединений"
}

variable ssh_source_ranges {
  description = "Тэг сети для входящих соединений"
  default     = ["0.0.0.0/0"]
}
