provider "google" {
  credentials = file("../GCP-creds/decisive-coda-355402-84a53c9a3ad1.json")
  project     = "decisive-coda-355402"
  region      = "us-central1"
  zone        = "us-central1-c"
}