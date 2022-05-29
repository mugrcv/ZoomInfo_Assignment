variable "vpc_id" { type = string }

variable "tg_name" { type = string }

variable "protocol_type" { default="HTTP"}

variable "tg_type" {default= "ip"}

variable "environ" { default="preprod"} # enviro tag to calculate the cost
