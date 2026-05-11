variable "cidr" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "name" {
  type = string
}

variable "desc" {
  type = string
}

variable "use_6_AZs" {
  type    = bool
  default = false
}

variable "is_public" {
  type    = bool
  default = false
}

variable "create_flowlog" {
  type    = bool
  default = true
}

variable "flowlog_iam_role" {
  type = string
}