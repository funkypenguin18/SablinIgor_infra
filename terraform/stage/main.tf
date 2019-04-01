terraform {
  # Версия terraform  # required_version = "0.11.7"
  backend "gcs" {
    bucket = "tfstate-reddit-app"
    prefix = "stage"
  }
}

provider "google" {
  # Версия провайдера
  version = "2.0.0"

  # ID проекта
  project = "${var.project}"
  region  = "${var.region}"
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  db_disk_image   = "${var.db_disk_image}"
}

module "vpc" {
  source            = "../modules/vpc"
  input_port        = "${var.input_port}"
  source_tag_name   = "${var.source_tag_name}"
  ssh_source_ranges = ["0.0.0.0/0"]
}

module "app" {
  source           = "../modules/app"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  app_disk_image   = "${var.app_disk_image}"
  db_address       = "${module.db.db_external_ip}:${var.input_port}"
}
