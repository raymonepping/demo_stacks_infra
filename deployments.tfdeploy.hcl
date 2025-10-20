# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

deployment "development" {
  inputs = {
    instances    = 1
    prefix       = "development"
    image        = "nginx:alpine"
    host_port    = 8080

    network_name = "stacks_net_development"

    # Two volumes: content + logs
    volume_names  = [
      "stacks_vol_dev_content",
      "stacks_vol_dev_logs",
    ]
    volume_mounts = {
      "stacks_vol_dev_content" = "/usr/share/nginx/html"
      "stacks_vol_dev_logs"    = "/var/log/nginx"
    }

#    volume_name  = "stacks_vol_development"
#    mount_path   = "/usr/share/nginx/html"
  }
}

deployment "production" {
  inputs = {
    instances    = 1
    prefix       = "production"
    image        = "nginx:alpine"
    host_port    = 8081

    network_name = "stacks_net_production"

    volume_names  = [
      "stacks_vol_prod_content",
      "stacks_vol_prod_logs",
    ]
    volume_mounts = {
      "stacks_vol_prod_content" = "/usr/share/nginx/html"
      "stacks_vol_prod_logs"    = "/var/log/nginx"
    }    
#    volume_name  = "stacks_vol_production"
#    mount_path   = "/usr/share/nginx/html"
  }
}