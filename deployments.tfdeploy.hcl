# deployments.tfdeploy.hcl

deployment "simple" {
  inputs = {
    prefix    = "ray"
    instances = 2
  }
}