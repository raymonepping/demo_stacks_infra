# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# ---------- Publish selected outputs for other Stacks ----------

# Development
publish_output "dev_app_url" {
  description = "URL for the development app"
  value       = deployment.development.app_url
}

publish_output "dev_network_name" {
  description = "Docker network name for development"
  value       = deployment.development.docker_network_name
}

# Production
publish_output "prod_app_url" {
  description = "URL for the production app"
  value       = deployment.production.app_url
}

publish_output "prod_network_name" {
  description = "Docker network name for production"
  value       = deployment.production.docker_network_name
}

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

  }
}