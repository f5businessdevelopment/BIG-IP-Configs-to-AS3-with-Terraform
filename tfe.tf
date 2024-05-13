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
  template = file("day0/tfcvariables.tf.example")
  vars = {
    org    = "STUDENT-${local.prefix}"
    works  = "workspace-${local.prefix}"
    prefix = "${local.prefix}"
    agentoken = tfe_agent_token.bigip-agent-token.token
  }
}

resource "local_file" "tfcvar" {
  content  = data.template_file.tfcvar.rendered
  filename = "day0/tfcvariables.tf"
}

data "template_file" "cloud" {
  template = file("day0/cloud.tf.example")
  vars = {
    org   = "STUDENT-${local.prefix}"
    works = "workspace-${local.prefix}"
  }
}
resource "local_file" "cloud" {
  content  = data.template_file.cloud.rendered
  filename = "day0/cloud.tf"
}

# Define a Terraform Cloud/Enterprise agent pool
resource "tfe_agent_pool" "bigip-agent-pool" {
  # Specifies the name of the agent pool
  name                 = "big-pool"
  
  # Specifies the organization to which the agent pool belongs
  organization         = tfe_organization.Org.name
  
  # Indicates whether the agent pool is scoped to the organization (default: true)
  organization_scoped  = true
}

# Generate an agent token for authentication with the agent pool
resource "tfe_agent_token" "bigip-agent-token" {
  # Specifies the ID of the agent pool to associate the token with
  agent_pool_id = tfe_agent_pool.bigip-agent-pool.id
  
  # Provides a description for the agent token
  description   = "bigip-agent-token"
}

