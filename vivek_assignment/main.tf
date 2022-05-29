####Main file where the required resources are created ####

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region     = var.region
  access_key = "AKIAZCGM3Z427IKDYKO7"
  secret_key = "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"
}


### storage of state file in s3 bucket as follows###

terraform {
  backend "s3" {
    bucket     = "terraform-statefiles-vivek"
    region     = "us-east-1"
    key        = "tf-state"
    access_key = "" ## will be using IAM role and will create the resources so leave as empty
    secret_key = "" ## will be using IAM role and will create the resources so leave as empty
  }
}

##### VPC creation ####

resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy 
  enable_dns_support   = var.dns_support 
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name    = "mainvpc"
    environ = var.environ
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    environ = var.environ
  }
}

###   subnets   ###


resource "aws_subnet" "private_subnet" {
  count             = var.pri_sb_count
  cidr_block        = element(var.pri_sub_cidr, count.index)
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = element(var.availability_zones, "${count.index}")

  tags = {
    Name    = "private_subnet_${count.index}"
    environ = var.environ
  }
}

### route tables and its assocaitions ###
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name    = "private_route_table"
    environ = var.environ
  }
}


resource "aws_route_table_association" "private" {
  count          = var.pri_sb_count
  route_table_id = aws_route_table.private_route.id
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
}


#### IAM role ###

resource "aws_iam_policy" "ecr_image_pull" {
  name        = "ecr-image-pull"
  description ="Image pull access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:GetRegistryPolicy",
                "ecr:DescribeImageScanFindings",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:GetDownloadUrlForLayer",
                "ecr:DescribeRegistry",
                "ecr:DescribePullThroughCacheRules",
                "ecr:DescribeImageReplicationStatus",
                "ecr:GetAuthorizationToken",
                "ecr:ListTagsForResource",
                "ecr:ListImages",
                "ecr:BatchGetRepositoryScanningConfiguration",
                "ecr:GetRegistryScanningConfiguration",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:DescribeRepositories",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetRepositoryPolicy",
                "ecr:GetLifecyclePolicy"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attachement-policy" {
  role       = "ecsTaskExecutionRole"
  policy_arn = aws_iam_policy.ecr_image_pull.arn
}
