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

variable "volume_name"    { 
  type = string
  default = "stacks_vol" 
}

variable "mount_path"     { 
  type = string
  default = "/usr/share/nginx/html" 
}

required_providers {
  docker = {
    source  = "kreuzwerker/docker"
    version = "~> 3.0"
  }

#  random = {
#    source  = "hashicorp/random"
#    version = "~> 3.7.2"
#  }

#  null = {
#    source  = "hashicorp/null"
#    version = "~> 3.2.2"
#  }
}

# provider "random" "this" {}
# provider "null" "this" {}
provider "docker" this {}

# component "pet" {
#  source = "./pet"

#  inputs = {
#    prefix = var.prefix
#  }

#  providers = {
#    random = provider.random.this
#  }
#}

#component "nulls" {
#  source = "./nulls"

#  inputs = {
#    pet       = component.pet.name
#    instances = var.instances
#  }

#  providers = {
#    random = provider.random.this
#  }
#}

# Network component (./network)
component "network" {
  source = "./network"
  inputs = { name = var.network_name }
  providers = { docker = provider.docker.this }
}

# Storage component (./storage)
component "storage" {
  source = "./storage"
  inputs = { name = var.volume_name }
  providers = { docker = provider.docker.this }
}

component "app" {
  source = "./app"
  inputs = {
    name      = "hug-nginx-${var.prefix}"
    image     = var.image
    host_port = var.host_port
  }
  providers = {
    docker = provider.docker.this
  }
  depends_on = [component.pet]
}