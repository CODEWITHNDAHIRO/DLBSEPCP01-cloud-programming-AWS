#==================================================================================
# TERRAFORM CONFIGURATION - AWS PROVIDER SETUP
#==================================================================================
terraform {
    required_version = ">=1.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}
provider "aws" {
    region = var.aws_region

    default_tags {
        tags = {
            project  = "Cloud Programming"
            Environment = "Production"
            Managedby = "Terraform"
            Name     = "Ndahiro-Putine-Jonathan"
        }
    }
}
# Getting available AZs
data "aws_availability_zones" "available"{
    state = "available"
}
#=======================================================================================================
#CREATING VIRTUAL PRIVATE CLOUD 
#=======================================================================================================
resource "aws_vpc" "main" {
    cidr_block    = var.vpc_cidr
    enable_dns_hostnames  = true
    enable_dns_support  = true

    tags = {
        Name = "iu-vpc"
    }
}

#INTERNET GATEWAY

resource "aws_internet_gateway" "main"{
    vpc_id = aws_vpc.main.id 

    tags = { 
      Name = "iu-igw"
    }

}
#PUBLIC SUBNET AZ-1

resource "aws_subnet" "Public_az1" {
    vpc_id       = aws_vpc.main.id 
    cidr_block   = var.Public_subnet_az1_cidr
    availability_zone  = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "iu-public-subnet-az1"
        Type = "public"
    }
}

# CREATING PUBLIC SUBNET AZ-2

resource "aws_subnet" "Public_az2" {
    vpc_id      =  aws_vpc.main.id 
    cidr_block  =  var.Public_subnet_az2_cidr
    availability_zone  = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch  = true 

    tags = {
        Name = "iu-public-subnet-az2"
        Type = "Public"

    }
}
 # CREATING PRIVATE SUBNET AZ-1 
resource "aws_subnet" "private_az1" {
     vpc_id   = aws_vpc.main.id
     cidr_block  = var.private_subnet_az1_cidr 
     availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "iu-private-subnet-az1"
        Type = "Private"
    }
}

#CREATING PRIVATE SUBNET AZ-2
 resource "aws_subnet" "private_az2"{
    vpc_id      = aws_vpc.main.id 
    cidr_block  = var.private_subnet_az2_cidr
    availability_zone = data.aws_availability_zones.available.names[1]

    tags = {
        Name = "iu-private-subnet-az2"
        Type = "private"
    }
 }

#=====================================================================================================================================
#CREATING PUBLIC ROUTE TABLE
#=====================================================================================================================================
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route{ 
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "iu-public-rt"
    }
}

# CREATING PRIVATE ROUTE TABLE 
 resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "iu-private-rt"
    }
 }
 
# PUBLIC SUBNET AZ-1 WITH PUBLIC ROUTE 

resource "aws_route_table_association" "public_az1"{
    subnet_id  = aws_subnet.Public_az1.id
    route_table_id = aws_route_table.public.id 
}
#ASSOCIATING PUBLIC SUBNET AZ-2 WITH PUBLIC ROUTE TABLE 
resource "aws_route_table_association" "public_az2"{
    subnet_id  = aws_subnet.Public_az2.id
    route_table_id = aws_route_table.public.id 
}
#PRIVATE SUBNET AZ-1 WITH PRIVATE ROUTE TABLE 
resource "aws_route_table_association" "private_az1"{
    subnet_id   = aws_subnet.private_az1.id
    route_table_id = aws_route_table.private.id 
}
#PRIVATE SUBNET AZ-2 WITH PRIVATE ROUTE TABLE 
resource "aws_route_table_association" "private_az2"{
    subnet_id = aws_subnet.private_az2.id 
    route_table_id = aws_route_table.private.id 
}

#CREATING ALB Security Group
resource "aws_security_group" "alb"{
    name = "iu-alb-sg"
    description = "security for application load balancer"
    vpc_id = aws_vpc.main.id 

    ingress {
        description = "HTTP from anywhere"
        from_port = 80
        to_port = 80
        protocol = "tcp" 
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTPS from anywhere"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "iu-alb-sg"

    }
}
#=========================================================================================================
# EC2 SECURITY GROUP 
#=========================================================================================================
resource "aws_security_group" "ec2"{
    name = "iu-ec2-sg"
    description = "Security group for EC2 instances"
    vpc_id    = aws_vpc.main.id

    ingress {
        description = "HTTP from ALB only"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
    egress {
        description = "All outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "iu-ec2-sg"
    }
}