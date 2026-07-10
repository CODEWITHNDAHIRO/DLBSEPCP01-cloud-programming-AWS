#================================================================================================
# IAM ROLE 
#================================================================================================
resource "aws_iam_role" "ec2_role" {
  name_prefix = "iu-ec2-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "iu-ec2-role"
  }
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name_prefix = "iu-cloudwatch-policy-"
  role        = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name_prefix = "iu-ec2-profile-"
  role        = aws_iam_role.ec2_role.name
}

locals {
  user_data_script = base64encode(<<-EOF
#!/bin/bash
yum update -y 
yum install -y httpd 
systemctl start httpd
systemctl enable httpd
cat > /var/www/html/index.html <<'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>IU Cloud Programming - Task 1</title>
<style>
body{font-family:Courier New;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:white;display:flex;justify-content:center;align-items:center;min-height:100vh;margin:0}
.container{text-align:center;background:rgba(0,0,0,0.3);padding:50px;border-radius:15px;max-width:600px}
h1{font-size:2.5em;margin:0 0 20px 0}
p{font-size:1.1em;margin:10px 0;line-height:1.6}
.info-box{margin-top:30px;padding:20px;background:rgba(255,255,255,0.1);border-radius:10px;border-left:4px solid #667eea}
.instance-id{font-size:0.9em;background:rgba(255,255,255,0.05);padding:10px;border-radius:5px;word-break:break-all;margin-top:10px}
.status{margin-top:20px;padding:10px;background:rgba(76,175,80,0.2);border-radius:5px;color:#c8e6c9}
</style>
</head>
<body>
<div class="container">
<h1>Load Balancing Active!</h1>
<p><strong>Student:</strong> Ndahiro Putine Jonathan</p>
<p><strong>Course:</strong> DLBSEPCP01_E - Cloud Programming</p>
<p><strong>Task:</strong> Task 1 - Global High-Availability Website</p>
<div class="info-box">
<p><strong>Served by instance:</strong> $(hostname)</p>
<p><strong>Region:</strong> eu-central-1</p>
<p><strong>Infrastructure:</strong> Auto-scaled compute node</p>
<p><strong>Web Server:</strong> Nginx</p>
<div class="instance-id">
<strong>Instance ID:</strong><br>
$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
</div>
</div>
<div class="status">
Instance deployed and running successfully
</div>
</div>
</body>
</html>
HTMLEOF
EOF
  )
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_launch_template" "main" {
  name_prefix   = "iu-lt-"
  image_id      = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = "t3.micro"

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  monitoring {
    enabled = true
  }

  user_data = local.user_data_script

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "iu-ec2-instance"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
}