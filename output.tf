output "public_ip_addr" {
  value = google_compute_address.static_ip.address

}
