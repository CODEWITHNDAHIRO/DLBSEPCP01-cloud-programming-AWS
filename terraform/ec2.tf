#=================================================================================================
# Data source to get latest Ubuntu 24.04 AMI
#=================================================================================================
data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_iam_role" "ec2_role" {
  name_prefix = "iu-ec2-role-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
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
    Statement = [{
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
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name_prefix = "iu-ec2-profile-"
  role        = aws_iam_role.ec2_role.name
}

resource "aws_launch_template" "main" {
  name_prefix   = "iu-lt-"
  image_id      = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = "t3.micro"

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  vpc_security_group_ids = [aws_security_group.ec2.id]

  monitoring {
    enabled = true
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
set -e
apt-get update -y
apt-get install -y python3
mkdir -p /var/www/html
cat > /var/www/html/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head><title>Load Balancing Active!</title></head>
<body>
<h1>IU CLOUD PROGRAMMING ASSIGNMENT!</h1>
<p>NAME: Ndahiro Putine Jonathan</p>
<p>Course: DLBSEPCP01_E</p>
<p>Instance: $INSTANCE_ID</p>
</body>
</html>
HTML
cd /var/www/html
nohup python3 -m http.server 80 > /tmp/server.log 2>&1 &
EOF
  )

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

  lifecycle {
    create_before_destroy = true
  }
}