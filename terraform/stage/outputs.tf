output "app_external_ip" {
  value = "${module.app.app_external_ip}"
}
output "db_external_ip" {
  value = "${module.db.db_external_ip}"
}

output "forwarding_rule_ip" {
  value = "${google_compute_forwarding_rule.reddit_forwarding_rule.ip_address}"
}
