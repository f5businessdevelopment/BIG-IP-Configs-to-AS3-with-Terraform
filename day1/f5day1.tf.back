terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.22.0"
    }
  }


  cloud {
    organization = "STUDENT-${var.prefix}"


    workspaces {
      name = "workspace-${var.prefix}"
    }
  }
}

resource "tfe_organization" "test" {
  name  = "STUDENT-${var.prefix}"
  email = "admin@company.com"
}

resource "tfe_variable_set" "bigip_credentials" {
  name         = "BIG-IP Credentials"
  description  = "BIGIP"
  global       = true
  organization = tfe_organization.test.name
}

resource "tfe_variable" "hostname" {
  key             = "hostname"
  value           = var.address
  category        = "terraform"
  description     = "a useful description"
  variable_set_id = tfe_variable_set.bigip_credentials.id
}

resource "tfe_variable" "username" {
  key             = "username"
  value           = "admin"
  category        = "terraform"
  description     = "an environment variable"
  variable_set_id = tfe_variable_set.bigip_credentials.id
}

resource "tfe_variable" "password" {
  key             = "password"
  value           = var.password
  category        = "terraform"
  description     = "an environment variable"
  variable_set_id = tfe_variable_set.bigip_credentials.id
}
