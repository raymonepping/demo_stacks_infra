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
  default = "postgres"
}

variable "image" {
  type    = string
  default = "postgres:16"
}

variable "host_port" {
  type    = number
  default = 5432
}

variable "db_password" {
  type = string
}

variable "network_name" {
  type    = string
  default = null
}

variable "volume_name" {
  type    = string
  default = null
}

variable "data_path" {
  type    = string
  default = "/var/lib/postgresql/data"
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = false
}

resource "docker_container" "this" {
  name  = var.name
  image = docker_image.this.image_id

  env = [
    "POSTGRES_PASSWORD=${var.db_password}",
  ]

  ports {
    internal = 5432
    external = var.host_port
  }

  dynamic "networks_advanced" {
    for_each = var.network_name == null ? [] : [var.network_name]
    content {
      name = networks_advanced.value
    }
  }

  dynamic "volumes" {
    for_each = var.volume_name == null ? [] : [var.volume_name]
    content {
      container_path = var.data_path
      read_only      = false
      volume_name    = volumes.value
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
