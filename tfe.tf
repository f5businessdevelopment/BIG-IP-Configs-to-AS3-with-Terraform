terraform {
  required_providers {
    tfe = {
      version = "~> 0.54.0"
    }
  }
}

locals {

  prefix = random_string.pre.result

}

resource "random_string" "pre" {
  length  = 4
  special = false
}


provider "tfe" {
  hostname = "app.terraform.io"
}

# Create an organization
resource "tfe_organization" "Org" {
  name  = "STUDENT-${local.prefix}"
  email = "s.shitole@f5.com"
  # ...
}

resource "tfe_workspace" "myworkspace" {
  name         = "workspace-${local.prefix}"
  organization = tfe_organization.Org.name
  tag_names    = ["workshop"]
}
output "Your_Workshop_HCP_Org" {
  value = "STUDENT-${local.prefix}"
}
output "Your_Workspace_configured" {
  value = "workspace-${local.prefix}"
}

output "prefix" {
  value = random_string.pre.result
}

data "template_file" "tfcvar" {
  template = file("Day0/tfcvariables.tf.example")
  vars = {
    org    = "STUDENT-${local.prefix}"
    works  = "workspace-${local.prefix}"
    prefix = "${local.prefix}"
  }
}

resource "local_file" "tfcvar" {
  content  = data.template_file.tfcvar.rendered
  filename = "Day0/tfcvariables.tf"
}

data "template_file" "cloud" {
  template = file("Day0/cloud.tf.example")
  vars = {
    org   = "STUDENT-${local.prefix}"
    works = "workspace-${local.prefix}"
  }
}
resource "local_file" "cloud" {
  content  = data.template_file.cloud.rendered
  filename = "Day0/cloud.tf"
}

