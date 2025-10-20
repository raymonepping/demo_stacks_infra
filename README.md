# demo_stacks_infra

This repository contains the **infrastructure Stack** for the HUG workshop.
It provisions the Docker **network**, **volumes**, and a basic **NGINX container**.
It also **publishes outputs** that can be consumed by downstream Stacks (such as [`demo_stacks_app`](https://github.com/raymonepping/demo_stacks_app)).

## Overview

* **Components**:

  * `network` → creates Docker networks
  * `storage` → provisions Docker volumes
  * `app` → runs a simple NGINX container on top of the above
* **Deployments**:

  * `development` → isolated dev network + volumes
  * `production` → isolated prod network + volumes

## Published Outputs

This Stack publishes key values that can be consumed by other Stacks:

* `dev_app_url`, `prod_app_url` → container endpoints
* `dev_network_name`, `prod_network_name` → Docker networks
* `dev_volume_names`, `prod_volume_names` → attached volumes

## Prerequisites

* Terraform **v1.13.x** or newer (Stacks GA requires 1.13+)
* Access to HCP Terraform with an Agent Pool that has Docker access

## Quickstart

1. Run the bootstrap script (clones both repos, validates, inits):

   ```bash
   bash setup_stacks.sh ~/work/hug-stacks
   ```
2. In HCP Terraform:

   * Create a new Stack and connect it to this repo.
   * Set execution mode to **Agent** and select your Agent Pool.
   * Deploy `development` and/or `production`.

## Local Verification

On the Agent host, after deploy:

```bash
docker network ls | grep stacks_net_
docker volume ls  | grep stacks_vol_
docker ps --format 'table {{.Names}}\t{{.Ports}}' | grep hug-nginx
curl -I http://localhost:8080  # dev
curl -I http://localhost:8081  # prod
```

## Notes

* This Stack is upstream to [`demo_stacks_app`](https://github.com/raymonepping/demo_stacks_app).
* Outputs published here can be consumed via `upstream_input` in other Stacks.
* This repository is designed for workshop/demo use, not production.
