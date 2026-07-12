# ============================================================================
# VPC OUTPUTS
# ============================================================================

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

# ============================================================================
# PUBLIC SUBNET OUTPUTS
# ============================================================================

output "public_subnet_az1_id" {
  description = "Public subnet in AZ1 ID"
  value       = aws_subnet.public_az1.id
}

output "public_subnet_az2_id" {
  description = "Public subnet in AZ2 ID"
  value       = aws_subnet.public_az2.id
}

# ============================================================================
# PRIVATE SUBNET OUTPUTS
# ============================================================================

output "private_subnet_az1_id" {
  description = "Private subnet in AZ1 ID"
  value       = aws_subnet.private_az1.id
}

output "private_subnet_az2_id" {
  description = "Private subnet in AZ2 ID"
  value       = aws_subnet.private_az2.id
}

# ============================================================================
# SECURITY GROUP OUTPUTS
# ============================================================================

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2.id
}

# ============================================================================
# ALB OUTPUTS
# ============================================================================

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

# ============================================================================
# EC2 AND LAUNCH TEMPLATE OUTPUTS
# ============================================================================

output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.main.id
}

output "iam_instance_profile_arn" {
  description = "IAM instance profile ARN"
  value       = aws_iam_instance_profile.ec2_profile.arn
}

# ============================================================================
# AUTO SCALING GROUP OUTPUTS
# ============================================================================

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.main.name
}

output "asg_min_size" {
  description = "Minimum instances"
  value       = aws_autoscaling_group.main.min_size
}

output "asg_max_size" {
  description = "Maximum instances"
  value       = aws_autoscaling_group.main.max_size
}

# ============================================================================
# DEPLOYMENT SUMMARY
# ============================================================================

output "deployment_region" {
  description = "AWS region where resources are deployed"
  value       = var.aws_region
}

output "deployment_note" {
  description = "Deployment status"
  value       = "VPC + Subnets + ALB + ASG created successfully"
}

#CLOUD FRONT CDN outputs 

output "cloudfront_domain_name" {
        description = "CloudFront distribution domain name (global endpoint for users)"
        value = aws_cloudfront_distribution.main.domain_name
    }
    output "cloudfront_distribution_id" {
        description = "Cloudfront distribution ID (for cache invalidation)"
        value = aws_cloudfront_distribution.main.id
    }
    output "cloudfront_url" {
        description = "Full CloudFront URL for testing"
        value = "https://${aws_cloudfront_distribution.main.domain_name}"

    }