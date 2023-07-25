# Домашнее задание к занятию "Продвинутые методы работы с Terraform" - "Мальцев Виктор"

------

### Задание 1

1. Возьмите из [демонстрации к лекции готовый код](https://github.com/netology-code/ter-homeworks/tree/main/04/demonstration1) для создания ВМ с помощью remote модуля.
2. Создайте 1 ВМ, используя данный модуль. В файле cloud-init.yml необходимо использовать переменную для ssh ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} .
Воспользуйтесь [**примером**](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/). Обратите внимание что ssh-authorized-keys принимает в себя список, а не строку!
3. Добавьте в файл cloud-init.yml установку nginx.
4. Предоставьте скриншот подключения к консоли и вывод команды ```sudo nginx -t```.

Ответ:

![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_1.png)

------

### Задание 2

1. Напишите локальный модуль vpc, который будет создавать 2 ресурса: **одну** сеть и **одну** подсеть в зоне, объявленной при вызове модуля. например: ```ru-central1-a```.
2. Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks .
3. Модуль должен возвращать в виде output информацию о yandex_vpc_subnet
4. Замените ресурсы yandex_vpc_network и yandex_vpc_subnet, созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.
5. Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.vpc_dev
6. Сгенерируйте документацию к модулю с помощью terraform-docs.    
 
Пример вызова:
```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}

Ответ:

1.
![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_2.png)


2.
![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_3.png)

```

### Задание 3
1. Выведите список ресурсов в стейте.
2. Полностью удалите из стейта модуль vpc.
3. Полностью удалите из стейта модуль vm.
4. Импортируйте все обратно. Проверьте terraform plan - изменений быть не должно.
Приложите список выполненных команд и скриншоты процессы.

Ответ:

1. terraform state list
![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_4.png)

2. terraform show
ID ресурсов, которые пондобятся при восстановлении

3. Полностью удалите из стейта модуль vpc.
terraform state rm 'module.vpc_dev'
![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_5.png)

4. Полностью удалите из стейта модуль vm.
terraform state rm 'module.test-vm'
![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_6.png)

5. Импортируйте все обратно. Проверьте terraform plan - изменений быть не должно.
terraform import 'module.vpc_dev.yandex_vpc_network.vpc_network' enpjieeif3nseh2m891m
terraform import 'module.vpc_dev.yandex_vpc_subnet.vpc_subnet'  e9b03s2isq6rtgrtlned
terraform import 'module.test-vm.yandex_compute_instance.vm[0]' fhmo1bo65uvba3l9oc0l

![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_7.png)

![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_8.png)

![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_9.png)

![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_10.png)


Предложенное обновление внутри "yandex_compute_instance.vm[0]" связано с добавлением строки "allow_stopping_for_update = true". Это означает, что если обновление ресурса требует остановки и последующего включения, Terraform автоматически будет выполнять эти действия. Если это значение не установлено, и остановка требуется для обновления, Terraform сообщит об ошибке.

Таким образом, Terraform планирует обновить этот ресурс, чтобы включить эту настройку. Это будет единственное изменение в этом плане.

Вместе с этим, Terraform также удаляет блок "timeouts", который, похоже, не имеет значений. Это нормально и не должно вызывать проблем, если блок timeouts не был задан в конфигурации.

```

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 


### Задание 4*

1. Измените модуль vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.  
  
Пример вызова:
```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}

Предоставьте код, план выполнения, результат из консоли YC.

Ответ:
![alt text](https://github.com/vmmaltsev/screenshot/blob/main/Screenshot_10.png)

data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=78040accecdf746a8bfcce08f2ce1299aac626fa72f7c0149ba23ffd889de9d6]
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.test-vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd85f37uh98ldl1omk30]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.test-vm.yandex_compute_instance.vm[0] will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "TODO: description; {{terraform managed}}"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "develop-web-0"
      + id                        = (known after apply)
      + labels                    = {
          + "env"     = "develop"
          + "project" = "undefined"
        }
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "user-data"          = <<-EOT
                #cloud-config
                users:
                  - name: ubuntu
                    groups: sudo
                    shell: /bin/bash
                    sudo: ['ALL=(ALL) NOPASSWD:ALL']
                    ssh_authorized_keys:
                      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0vmZ0SwUSFdPxf3xU5n1GiQeQMY1FbAN8LiK2/1+5U root@debian-s-1vcpu-2gb-fra1-01
                package_update: true
                package_upgrade: false
                packages:
                 - vim
                 - nginx
            EOT
        }
      + name                      = "develop-web-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd85f37uh98ldl1omk30"
              + name        = (known after apply)
              + size        = 10
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # module.vpc_dev.yandex_vpc_network.vpc_network will be created
  + resource "yandex_vpc_network" "vpc_network" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "develop"
      + subnet_ids                = (known after apply)
    }

  # module.vpc_dev.yandex_vpc_subnet.vpc_subnet[0] will be created
  + resource "yandex_vpc_subnet" "vpc_subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "develop-ru-central1-a"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.vpc_dev.yandex_vpc_subnet.vpc_subnet[1] will be created
  + resource "yandex_vpc_subnet" "vpc_subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "develop-ru-central1-b"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.2.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # module.vpc_dev.yandex_vpc_subnet.vpc_subnet[2] will be created
  + resource "yandex_vpc_subnet" "vpc_subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "develop-ru-central1-c"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.3.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-c"
    }

Plan: 5 to add, 0 to change, 0 to destroy.
 



