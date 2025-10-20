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
  default = "backend"
}

variable "image" {
  type    = string
  default = "hashicorp/http-echo"
}

variable "host_port" {
  type    = number
  default = 9000
}

variable "message" {
  type    = string
  default = "hello from backend"
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
  name    = var.name
  image   = docker_image.this.image_id
  command = ["-text", var.message]

  ports {
    internal = 5678
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
