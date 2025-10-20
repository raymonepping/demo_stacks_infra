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

resource "docker_network" "this" {
  name   = var.name
  driver = "bridge"
}

output "name" {
  value = docker_network.this.name
}
