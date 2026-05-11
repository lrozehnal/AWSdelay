variable "tags" {
  type = map(any)
}
variable "tg_port" {
   type = number
}

variable "listener_port" {
   type = number
}

variable "protocol" {
  type = string
  default = "TCP"
}

variable "name" {
  type = string
}

variable "domain" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets_id" {
  type = list
}

variable "client_vpc_id" {
  type = string
}

variable "client_subnets_id" {
  type = list
}


variable "target_ip" {
  type = string
}

variable "nlbregion" {
  type = string
}