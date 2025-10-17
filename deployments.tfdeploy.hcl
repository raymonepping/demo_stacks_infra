# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

deployment "simple" {
  inputs = {
    prefix           = "simple"
    instances        = 1
  }
}

deployment "complex" {
  inputs = {
    prefix           = "complex"
    instances        = 3
  }
}

deployment "app" {
  inputs = {
    name      = "hug-nginx"
    image     = "nginx:alpine"
    host_port = 8080
  }
}