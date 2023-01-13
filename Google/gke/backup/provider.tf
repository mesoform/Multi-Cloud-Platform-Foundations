terraform {
  required_providers {
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">=4.48.0, <5.0.0"
    }
  }
  required_version = ">=1.3.0"
}