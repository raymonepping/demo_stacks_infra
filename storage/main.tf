terraform {
  required_providers {
    docker = { source = "kreuzwerker/docker", version = "~> 3.0" }
  }
}

variable "name" {
  type = string
}

/* DELETE this block:
provider "docker" {}
*/

resource "docker_volume" "this" {
  name = var.name
}

output "name" {
  value = docker_volume.this.name
}
