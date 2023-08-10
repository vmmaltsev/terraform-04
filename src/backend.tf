terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tfstate-develop1"
    region     = "ru-central1"
    key        = "terraform.tfstate"

    skip_region_validation = true
    skip_credentials_validation = true

    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gnvmu4oqhl48jdq4s6/etn1t29dbo3r365mqbmt"
    dynamodb_table = "table199"
  }
}
