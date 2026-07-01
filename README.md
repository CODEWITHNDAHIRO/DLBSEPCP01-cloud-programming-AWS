# DLBSEPCP01-cloud-programming-AWS
IU DLBSEPCP01_E - Task 1: Global High-Availability AWS Website

**course:** Cloud Programming (DLBSEPCP01_E)
**Student:** Ndahiro Putine Jonathan
**Matrikulation:** 4242218

## APPROVED ARCHITECTURE

This project implements the conception phase approved by my assessor:
 - **Global Low Latency:** CloudFront CDN (5-50ms worldwide)
 - **High Availability:** Multi-AZ + ALB + ASG ( 99.99% uptime)
 - **Auto-Scaling:** CPU-based scaling (2-10 instances)
 - **Cost:** ~ 85/month (enteprise-grade)

 ## Project status 
 - [x] phase 1: Conception (approved)
 - [ ] phase 2: Development (in progress)
 - [ ] phase 3: Finalization (pending)

 ## Repository Structure
 terraform/              # Infrastructure as Code
├── main.tf            # VPC, subnets, security
├── variables.tf       # Input parameters
├── outputs.tf         # Output values
├── alb.tf            # Load balancer
├── ec2.tf            # EC2 instances
└── asg.tf            # Auto scaling
docs/                  # Documentation
├── architecture.md
└── deployment-guide.md
conception-phase/      # Phase 1 files
development-phase/     # Phase 2 files
finalization-phase/    # Phase 3 files