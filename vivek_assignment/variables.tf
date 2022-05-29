variable "region" { 
	default = "us-east-1" 
	}

variable "statebucket" { 
	default = "terraform-statefiles-vivek" 
	}

variable "instance_tenancy" {
	default = "default"
	}

variable "environ" { 
	default = "preprod" 
	}

variable "dns_support" { 
	default = true 
	}

variable "dns_hostnames" { 
	default = true 
	}

variable "vpc_cidr" {
	default = "172.28.0.0/16" 
	}


variable "pri_sub_cidr" {
	default = ["172.28.3.0/24", "172.28.4.0/24"] 
	}

variable "availability_zones" {
	default = ["us-east-1a", "us-east-1b"] 
	}


variable "pri_sb_count" {
	default = 2
	}

variable "tg_count" {
	default = 2
	}

variable "containers_name" {
	default = ["vivek1", "vivek2"] 
	}

variable "ep_type" { 
	default="Interface" 
	}

variable "epw_type" { 
	default="Gateway" 
	}

variable "ecr_api" { 
	default="com.amazonaws.us-east-1.ecr.api" 
	}

variable "dkr_api" { 
	default="com.amazonaws.us-east-1.ecr.dkr" 
	}

variable "s3_api" { 
	default="com.amazonaws.us-east-1.s3" 
	}

variable "cp_api" {
	default="com.amazonaws.us-east-1.logs"
	}

variable "ecs_autoscale_min_instances" {
	default="1"
	}

variable "ecs_autoscale_max_instances" {
	default="10"
	}

variable "service1_image" {
	default="623199899445.dkr.ecr.us-east-1.amazonaws.com/service1:latest"
	}

variable "service2_image" {
        default="623199899445.dkr.ecr.us-east-1.amazonaws.com/service2:latest"
       }

variable "dashboard1_name" {
	default="ECSService1"
	}

variable "service1_names" {
        default = ["service1_service"]
	}

variable "dashboard2_name" {
        default="ECSService2"
        }

variable "service2_names" {
        default = ["service2_service"]
        }

variable "aws_region" {
	default = "us-east-1"
	}

variable "cluster_name1" {
	default = "service1"
	}

variable "cluster_name2" {
        default = "service2"
        }
