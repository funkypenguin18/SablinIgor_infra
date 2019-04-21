# настойка правила файрвола для ssh-соединений
resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"

  # описание правила
  description = "Allow SSH connection from anywhere"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = "${var.ssh_source_ranges}"
}

# настройка правила файрвола для тестового приложения 
resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["${var.input_port}"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["${var.source_tag_name}"]
}

# настойка правила файрвола для ssh-соединений
resource "google_compute_firewall" "firewall_http" {
  name = "default-allow-https"

  # описание правила
  description = "Allow HTTP connection from anywhere"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = "${var.ssh_source_ranges}"
}
