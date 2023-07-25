variable "vpc_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "subnets" {
  description = "List of subnets to create"
  type        = list(object({
    zone = string
    cidr = string
  }))
}
