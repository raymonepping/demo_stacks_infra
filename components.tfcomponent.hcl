# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  type = string
}

variable "instances" {
  type = number
}

variable "host_port" {
  type    = number
  default = 8080
}

variable "image" {
  type    = string
  default = "nginx:alpine"
}

variable "network_name"   { 
  type = string 
  default = "stacks_net" 
}

variable "volume_names" {
  type    = list(string)
  default = []
}
variable "volume_mounts" {
  type    = map(string)
  default = {}
}

variable "volume_name"    { 
  type = string
  default = "stacks_vol" 
}

variable "mount_path"     { 
  type = string
  default = "/usr/share/nginx/html" 
}

variable "fe_host_port" { 
  type = number  
  default = 8081 
}

variable "be_host_port" { 
  type = number  
  default = 9000 
}

required_providers {
  docker = {
    source  = "kreuzwerker/docker"
    version = "~> 3.0"
  }
}

provider "docker" this {}

# Network component (./network)
component "network" {
  source = "./network"
  inputs = { name = var.network_name }
  providers = { docker = provider.docker.this }
}

# Storage components (./storage): create one named volume per entry
component "storage" {
  for_each  = toset(var.volume_names)
  source    = "./storage"
  inputs    = { name = each.value }
  providers = { docker = provider.docker.this }
}

component "app" {
  source = "./app"
  inputs = {
    name         = "hug-nginx-${var.prefix}"
    image        = var.image
    host_port    = var.host_port
    network_name = var.network_name
    volume_names  = var.volume_names
    volume_mounts = var.volume_mounts
  }
  providers  = { docker = provider.docker.this }
  depends_on = [component.network, component.storage]
}