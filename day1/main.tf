terraform {
  cloud {
    organization = "STUDENT-BSkd"

    workspaces {
      name = "day1"
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

resource "bigip_ltm_monitor" "vs_tc1" {
  name     = "/Common/test_monitor_vs_tc1"
  parent   = "/Common/http"
  send     = "GET /some/path\r\n"
  timeout  = "999"
  interval = "990"
}

resource "bigip_ltm_pool" "vs_tc1" {
  name                = "/Common/test_pool_vs_tc1"
  load_balancing_mode = "round-robin"
  monitors            = [bigip_ltm_monitor.vs_tc1.name]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

resource "bigip_ltm_pool_attachment" "vs_tc1" {
  pool = bigip_ltm_pool.vs_tc1.name
  node = "10.0.0.171:80"
}

resource "bigip_ltm_virtual_server" "vs_tc1" {
  pool                       = bigip_ltm_pool.vs_tc1.name
  name                       = "/Common/test_vs_tc1"
  destination                = "10.0.0.200"
  port                       = 8080
  source_address_translation = "automap"
}
