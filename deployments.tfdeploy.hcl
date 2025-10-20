# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

deployment "simple" {
  inputs = {
    instances    = 1
    prefix       = "simple"
    db_password  = "examplepassword"
    image        = "nginx:alpine"
    host_port    = 8080

    network_name = "stacks_net_simple"
    volume_name  = "stacks_vol_simple"
    mount_path   = "/usr/share/nginx/html"
  }
}

deployment "complex" {
  inputs = {
    instances    = 1    
    prefix       = "complex"
    db_password  = "examplepassword"
    image        = "nginx:alpine"
    host_port    = 8081

    network_name = "stacks_net_complex"
    volume_name  = "stacks_vol_complex"
    mount_path   = "/usr/share/nginx/html"
  }
}