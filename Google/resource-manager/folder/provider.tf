terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">=3.55.0, <4.0.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">=3.55.0, <4.0.0"
    }
  }
}
