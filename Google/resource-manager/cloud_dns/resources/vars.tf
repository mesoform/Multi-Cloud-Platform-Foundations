variable "managed_zone" {}
variable "DNS" {}
variable "A_records" {
  default = []
}
variable "CNAME_records" {
  default = []
}
variable "TXT_records" {
  default = []
}
variable "MX_records" {
  default = []
}