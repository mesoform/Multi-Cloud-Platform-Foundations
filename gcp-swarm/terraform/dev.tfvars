project_id = "pk2m-testing"
service_account = { email = "pk2m-service@pk2m-testing.iam.gserviceaccount.com", scopes = ["userinfo-email", "compute-ro", "storage-ro"] }
network_name = "swarm"
region = "europe-west2"
gcp_ssh_user = "debian"
gcp_public_key_path = "~/.ssh/id_rsa.pub"
target_size = 3
secure_source_ip = "147.161.96.35"