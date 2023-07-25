resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name        = var.cluster_name
  network_id  = var.network_id

  environment = "PRESTABLE"
  version     = "5.7"

  resources {
    resource_preset_id = "s2.micro"
    disk_size = 10
    disk_type_id = "network-hdd"
  }

  database {
    name = "default"
  }

  user {
    name = "test"
    password = "your_password" //Replace with your password
    permission {
      database_name = "default"
    }
  }

  dynamic "host" {
    for_each = var.HA ? ["a", "b", "c"] : ["a"]
    content {
      zone           = "ru-central1-${host.value}"
      subnet_id      = var.subnet_id
      assign_public_ip = true
    }
  }
}

 hosts {
    host {
      zone       = "ru-central1-a"
      subnet_id  = var.subnet_id[0]
    }
    host {
      zone       = "ru-central1-b"
      subnet_id  = var.subnet_id[1]
    }
  }

output "cluster_id" {
  value = yandex_mdb_mysql_cluster.mysql_cluster.id
}
