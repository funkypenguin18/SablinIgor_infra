resource "google_compute_http_health_check" "reddit_healthcheck" {
  name               = "reddit-healthcheck"
  port               = "9292"
  timeout_sec        = 1
  check_interval_sec = 1
}

resource "google_compute_target_pool" "reddit_pool" {
  name = "reddit"

  instances = [
    "${module.app.app_self_link}",
  ]

  health_checks = [
    "${google_compute_http_health_check.reddit_healthcheck.name}",
  ]
}

resource "google_compute_forwarding_rule" "reddit_forwarding_rule" {
  name = "reddit-forwarding-rule"

  target = "${google_compute_target_pool.reddit_pool.self_link}"

  port_range = "9292"
}
