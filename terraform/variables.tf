variable "resource_group_name" {
    type = string
}

variable "resource_group_location" {
    type = string
    default = "West Europe"
}


variable "prefix" {
    type = string
}

variable "environment" {
    type = string
}

variable  "app_appinsights_swag" {
    type = string
}


variable  "static_site_swag" {
    type = string
}

variable  "app_name" {
    type = string
}
