variable "launch_type" { default="FARGATE" }

variable "execution_role_arn" { default = "arn:aws:iam::623199899445:role/ecsTaskExecutionRole" }

variable "cpu_resource" { default="512" }

variable "ram_resource" { default="1024"}

variable "container_name" {  type = string }

variable "ecs_id" {  type = string }

variable "ecs_security_group" { type = string }

variable "ecs_subnet" { type = string }

variable "tg_arn" { type = string }

variable "image" { type = string }



