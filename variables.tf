variable "resource_group_name" {
    type = string
}

variable "dns_prefix" {
    type = string
}

variable "stockage_name" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "resource_group_location" {
    type = string
    default = "West Europe"
}

variable "environment" {
    type = string
}

variable "dns" {
    type = string
}
