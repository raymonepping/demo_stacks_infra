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
variable "image" { type     = string default = "nginx:alpine" }
variable "name" { type      = string default = "hug-nginx" }
variable "host_port" { type = number default = 8080 }

# Optional attachments
variable "network_name" { type = string default = null }
variable "volume_name"  { type = string default = null }
variable "mount_path"   { type = string default = "/usr/share/nginx/html" }

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

  # Attach network if provided
  dynamic "networks_advanced" {
    for_each = var.network_name == null ? [] : [var.network_name]
    content {
      name = networks_advanced.value
    }
  }

  # Attach volume if provided
  dynamic "volumes" {
    for_each = var.volume_name == null ? [] : [var.volume_name]
    content {
      container_path = var.mount_path
      read_only      = false
      volume_name    = volumes.value
    }
  }

  restart = "unless-stopped"
}

output "nginx_container_name" { value = docker_container.nginx.name }
output "nginx_container_port" { value = docker_container.nginx.ports[0].external }