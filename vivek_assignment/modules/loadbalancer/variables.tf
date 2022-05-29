variable "lb_type" { default="application"} #type of load balancer
 
variable "alb_name" { type = string } #name of the load balancer
 
variable "alb_sg" { type = list(string) } #SG of the load balancer

variable "alb_subnet" { type = list } #Subnet of the load balancer

variable "alb_type" { type = bool } #internel or external load balancer

variable "environ" {  default="preprod"} # enviro tag to calculate the cost
  
