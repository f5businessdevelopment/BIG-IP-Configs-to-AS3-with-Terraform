terraform {
  cloud {
    organization = "STUDENT-BSkd"

    workspaces {
      name = "AS3app"
    }
  }
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.22.0"
    }
  }
}

provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = var.username
  password = var.password
}
# Example Usage for json file
resource "bigip_as3" "as3-example1" {
  as3_json = file("vs_tc1.json")
}

