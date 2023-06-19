variable "default_route" {
  type        = string
  description = "Default Route from and to internet"
  default     = "0.0.0.0/0"
}

variable "vpc_cc_route"{
  type = string
  description ="route to vpc cc (private subnet)"
  default = "" 
}

variable "vpc_cp_route"{
  type = string
  description ="route to vpc cp (private subnet)"
  default = "" 
}
