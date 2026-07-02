variable "aws_region" {
    description = "AWS region for deployment"
    type        = string
    default     = "eu-central-1"
} 
#variable-2 VPC CIDR
 variable "vpc_cidr" {
    description = "VPC CIDR block"
    type        = string 
    default     = "10.0.0.0/16"
 }
 #variable-3 public subnet AZ1
 variable "Public_subnet_az1_cidr" {
    description = " Public subnet in AZ1 CIDR"
    type  = string
    default  = "10.0.1.0/24"
 }
 #variable-4 Public Subnet AZ2
 variable "Public_subnet_az2_cidr"{
  description = "Public  subnet in AZ2 CIDR"
  type  = string
  default = "10.0.2.0/24"
 }
 #variable-5 private subnet AZ1
 variable "private_subnet_az1_cidr"{
    description = "Private subnet in AZ1 CIDR"
    type  = string
    default  = "10.0.11.0/24"
}
#variable-6 private subnet AZ2
 variable "private_subnet_az2_cidr"{
    description = "Private subnet in AZ2 CIDR"
    type       = string 
    default    = "10.0.12.0/24"
 }
