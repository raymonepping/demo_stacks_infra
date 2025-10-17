# components.tfcomponent.hcl

variable "prefix" {
  type    = string
  default = "stacks-demo"
}

variable "instances" {
  type    = number
  default = 1
}

# Keep provider constraints broad enough to satisfy module pins
required_providers {
  random = {
    source  = "hashicorp/random"
    version = ">= 3.3.2, < 4.0.0"
  }
  null = {
    source  = "hashicorp/null"
    version = ">= 3.1.1, < 4.0.0"
  }
}

provider "random" "this" {}
provider "null" "this" {}

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
    pet       = component.pet.outputs.name   # <- correct GA syntax
    instances = var.instances
  }
  providers = {
    null = provider.null.this
  }
}
