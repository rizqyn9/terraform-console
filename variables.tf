variable "project" {
  description = "The GCP project to use."
}

variable "region" {
  description = "The GCP region to deploy to."
}

variable "zone" {
  description = "The GCP zone to deploy to."
}

variable "credentials" {
  description = "base64 google credentials"
}

variable "env" {
  default = "dev"
}
