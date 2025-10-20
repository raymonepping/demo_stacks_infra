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
  type = string 
  default = "nginx:alpine" 
}

variable "name" { 
  type = string 
  default = "hug-nginx" 
}

variable "host_port" { 
  type = number 
  default = 8080 
}

# Optional attachments
variable "network_name" { 
  type = string 
  default = null 
}
variable "volume_name"  { 
  type = string 
  default = null 
}
variable "mount_path"   { 
  type = string 
  default = "/usr/share/nginx/html" 
}

variable "volume_names" {
  type    = list(string)
  default = []
}
variable "volume_mounts" {
  type    = map(string)
  default = {}
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

  # Attach network if provided
  dynamic "networks_advanced" {
    for_each = var.network_name == null ? [] : [var.network_name]
    content {
      name = networks_advanced.value
    }
  }

  # Attach any number of named volumes
  dynamic "volumes" {
    for_each = var.volume_names
    content {
      volume_name    = volumes.value
      # Use provided mount if present, else default to /data/<volume_name>
      container_path = lookup(var.volume_mounts, volumes.value, format("/data/%s", volumes.value))
      read_only      = false
    }
  }

  restart = "unless-stopped"
}

output "nginx_container_name" { 
  value = docker_container.nginx.name 
}

output "nginx_container_port" { 
  value = docker_container.nginx.ports[0].external 
}