variable "firewall-name" {
  type    = string
  default = "Cloudideastar-aws-network-firewall"
}


variable "http-domains-to-deny" {
  type    = list
  default = ["test.example.com"]
}
variable "https-domains-to-deny" {
  type    = list
  default = ["test.example.com"]
}

