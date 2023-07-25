#resource "yandex_vpc_network" "develop" {
  #name = var.vpc_name
#}
#resource "yandex_vpc_subnet" "develop" {
  #name           = var.vpc_name
  #zone           = var.default_zone
  #network_id     = yandex_vpc_network.develop.id
  #v4_cidr_blocks = var.default_cidr
#}

module "vpc_dev" {
  source   = "/root/homeworks/terraform-04/src/vpc"
  vpc_name = "develop"
   subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "mysql_cluster" {
  source       = "./mysql_cluster"
  cluster_name = "example"
  network_id   = module.vpc_dev.network_id
  subnet_id  = [module.vpc_dev.subnet_ids["ru-central1-a"], module.vpc_dev.subnet_ids["ru-central1-b"]]
  HA          = true // change to false for single instance
  security_group_id = "your-security-group-id"
}

module "mysql_db_user" {
  source      = "./mysql_db_user"
  cluster_id  = module.mysql_cluster.cluster_id
  db_name     = "test"
  username    = "app"
  password    = "yourpassword"
}


module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = "develop"
  network_id      = module.vpc_dev.network_id
  subnet_zones    = module.vpc_dev.subnet_zones
  subnet_ids      = values(module.vpc_dev.subnet_ids)
  instance_name   = "web"
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true
  
  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    vms_ssh_root_key = var.vms_ssh_root_key
  }
}
