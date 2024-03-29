terraform {
  required_version = ">=v1.3.0"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">=4.0.0, <5.0.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">=4.0.0, <5.0.0"
    }
  }
}
