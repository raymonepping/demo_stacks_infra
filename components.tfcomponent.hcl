# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  type = string
}

variable "instances" {
  type = number
}

required_providers {
  docker = {
    source  = "kreuzwerker/docker"
    version = "~> 3.0"
  }

  random = {
    source  = "hashicorp/random"
    version = "~> 3.5.1"
  }

  null = {
    source  = "hashicorp/null"
    version = "~> 3.2.2"
  }
}

provider "random" "this" {}
provider "null" "this" {}
provider "docker" {}

component "pet" {
  source = "./pet"

  inputs = {
    prefix = var.prefix
  }

  providers = {
    random = provider.random.this
  }
}

component "nulls" {
  source = "./nulls"

  inputs = {
    pet       = component.pet.name
    instances = var.instances
  }

  providers = {
    null = provider.null.this
  }
}

component "app" {
  source = "./app"
  # Optional, if you want the container name to include the pet
  inputs = {
    name      = "hug-nginx"
    image     = "nginx:alpine"
    host_port = 8080
  }
  providers = {
    docker = provider.docker
  }
  depends_on = [component.pet]  # ensures pet evaluates first if you reference it
}