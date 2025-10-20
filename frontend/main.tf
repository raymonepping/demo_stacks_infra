terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

variable "name" {
  type    = string
  default = "frontend"
}

variable "image" {
  type    = string
  default = "nginx:alpine"
}

variable "host_port" {
  type    = number
  default = 8080
}

variable "network_name" {
  type    = string
  default = null
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = false
}

resource "docker_container" "this" {
  name  = var.name
  image = docker_image.this.image_id

  ports {
    internal = 80
    external = var.host_port
  }

  dynamic "networks_advanced" {
    for_each = var.network_name == null ? [] : [var.network_name]
    content {
      name = networks_advanced.value
    }
  }

  restart = "unless-stopped"
}

output "name" {
  value = docker_container.this.name
}

output "host_port" {
  value = var.host_port
}
