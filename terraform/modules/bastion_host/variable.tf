variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet" {
  type = list(string)
}

variable "vpc_endpoints_sg" {
  type = string
}


