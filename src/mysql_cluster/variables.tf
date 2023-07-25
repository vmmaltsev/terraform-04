variable "cluster_name" {
  description = "The name of the MySQL cluster."
  type        = string
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "HA" {
  description = "Whether the MySQL cluster should be highly available or not."
  type        = bool
  default     = false
}

variable "security_group_id" {
  description = "Security group for the cluster."
  type        = string
}

variable "network_id" {
  description = "The ID of the network in which to create the cluster."
  type        = string
}

variable "subnet_id" {
  description = "The subnet id to create the MySQL instance in"
  type        = list(string)
  default     = []
}
