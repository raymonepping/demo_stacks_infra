# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Optional inputs if you want to override later
variable "image" {
  type    = string
  default = "nginx:alpine"
}

variable "name" {
  type    = string
  default = "hug-nginx"
}

variable "host_port" {
  type    = number
  default = 8080
}


resource "docker_image" "nginx" {
  name         = var.image
  keep_locally = false
}

resource "docker_container" "nginx" {
  name  = var.name
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.host_port
  }
}

output "nginx_container_name" {
  value = docker_container.nginx.name
}

output "nginx_container_port" {
  value = docker_container.nginx.ports[0].external
}
