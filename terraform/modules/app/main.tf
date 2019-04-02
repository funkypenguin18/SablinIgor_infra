resource "google_compute_address" "app_ip" {
  count = "${var.node_count}"
  name  = "reddit-app-ip-${count.index}"
}

data "template_file" "servive" {
  template = "${file("${path.module}/puma.service")}"

  vars = {
    db_address = "${var.db_address}"
  }
}

resource "google_compute_instance" "app" {
  count        = "${var.node_count}"
  name         = "reddit-app${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {
      nat_ip = "${element(google_compute_address.app_ip.*.address, count.index)}"
    }
  }

  metadata {
    # путь до публичного ключа
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type  = "ssh"
    user  = "appuser"
    agent = false

    # путь до приватного ключа
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    content     = "${data.template_file.servive.rendered}"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "../files/deploy.sh"
  }
}
