variable "project_id" {
  type    = string
  default = "waisiterraform"
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "state_bucket" {
  type    = string
  default = "waisi-terraform"
}

variable "cluster_name" {
  type    = string
  default = "waisi-terraform"
}

variable "service_name" {
  type    = string
  default = "waisi-terraform-edu"
}

variable "k8s_version" {
  type = string
  default = 1.29
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 3
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "preemptible" {
  type    = bool
  default = true
}
