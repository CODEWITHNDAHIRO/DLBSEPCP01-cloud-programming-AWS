#=====================================================================================
# VPC OUTPUTS
#=====================================================================================

output "vpc_id" {
    description = "VPC ID"
    value       = aws_vpc.main.id 
}

output "vpc_cidr" {
    description = "VPC CIDR block"
    value       = aws_vpc.main.cidr_block 
}

output "internet_gateway_id" {
    description = "Internet Gateway ID"
    value       = aws_internet_gateway.main.id 
}
#================================================================================================
#PUBLIC SUBNET OUTPUTS
#================================================================================================
output "Public_subnet_az1_id"{
    description  = "Public subnet in AZ1 ID"
    value        = aws_subnet.Public_az1.id 
 }

output "Public_subnet_az2_id" {
    description = "Public subnet in AZ2 ID"
    value       = aws_subnet.Public_az2.id 
 }

 #================================================================================================
 # PRIVATE SUBNET OUTPUTS
 #================================================================================================

 output "private_subnet_az1_id" {
     description = "Private subnet in AZ1 ID"
     value      = aws_subnet.private_az1.id 
 }

output "private_subnet_az2_id" {
    description = "Private subnet in AZ2 ID"
    value    = aws_subnet.private_az2.id 
}
#==================================================================================================
#SECURITY GROUP OUTPUTS 
#==================================================================================================

output "alb_security_group_id" {
    description = "ALB Security Group ID"
    value    = aws_security_group.alb.id 
}
 
output "ec2_security_group_id" {
    description = "EC2 Security Group ID"
    value     = aws_security_group.ec2.id 
}

output "deployment_summary" {
    description = "Description summmary"
    value  = "VPC Foundation created successfully"
}