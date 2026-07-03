h#================================================================================================
# IAM Role 
#================================================================================================

resource "aws_iam_role" "ec2_role" {
    name_prefix = "iu-ec2-role-"

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    service = "ec2.amazonaws.com"
                }
            }
        ]
    })
    tags = {
        Name = "iu-ec2-role"
    }
}

# IAM Role Policy 
 
 resource "aws_iam_role_policy" "cloudwatch_policy" {
    name_prefix = "iu-cloudwatch-policy-"
    role     = aws_iam_role.ec2_role.id 
    
    policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "cloudwatch:PutMetricData",
                    "ec2:DescribeVolumes"'
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

# IAM Instance Profile

resource "aws_iam_instance_profile" "ec2_profile" {
    name_prefix = "iu-ec2-profile-"
    role  = aws_iam_role.ec2_role.name 
}

#=======================================================
#USER DATA SCRIPT 
#=======================================================

locals{
    user_data_script = base64encode(<<-EOF 
    #!/bin/bash
    set -e 

    #Update system packages
    apt-get update -y
    apt-get upgrade -y

    #installing Nginx web server
    systemctl enable nginx  
    systemctl start nginx
    
    #Create custom hello world page 
    cat > /var/www/html/index.html <<HTML 
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name = "viewport content = "width=device-width, initial -scale=1.0">
        <title>IU Cloud Programming - Task 1</title>
        <style>
            *{
                margin: 0;
                padding: 0;
                box-sizing: border-box;

            }
            body{
                font-family: 'Courier New' , monospace;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                text-align: center;
                background: rgba(0, 0, 0, 0.3);
                padding: 50px;
                border-radius: 15px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
                max-width: 600px;
            }
            p{
                font-size: 1.1em;
                margin: 10px 0;
                line-height: 1.6;
            }
            .info-box {
                margin-top: 30px;
                padding: 20 px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 10px;
                border-left: 4px solid #667eea;
            }

            .instance-id{
                font-size: 0.9 em;
                background: rgba(255, 255, 255, 0.05);
                padding: 10px;
                border-radius: 5 px;
                font-family: 'Courier New', monospace;
                word-break: break-all;
                margin-top: 10px;
            
            }
            .status {
                margin-top: 20px;
                padding: 10px;
                background: rgba(76, 175, 80, 0.2);
                border-radius: 5px;
                color: #c8e6c9;
            }
        </style>
    </head>
</body>
    <div class="container">
        <h1> Load Balancing Active!</h1>

        <p><strong>Student:</strong>NDAHIRO Putine Jonathan</p>
        <p><strong>Course:</strong>DLBSEPCP01_E - Cloud Programming</p>
        <p>strong>Task:</strong> Task 1 - Global High-Availability Website</p>

        <div class= "info-box">
            <p><strong>Served by instance:</strong> \$(hostname)</p>
            <p><strong>Region:</strong> eu-central-1</p>
            <p><strong>Infrastructure:</strong> Auto-scaled compute node</p>
            <p><strong>Web Server:</strong> Nginx</p>

            <div class="instance-id">
                <strong>Instance ID:</strong><br>
                \$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
            </div>
        </div>

        <div class="status">
        INSTANCE DEPLOYED AND RUNNING SUCCESSFULLY 
        </div>
    </div>
  </body>
  </html>
  HTML 
EOF 
 )
}

#=========================================================================
# LAUNCH TEMPLATE
#=========================================================================

resource "aws_launch_template" "main"{
    name_prefix = "iu-lt-"
    image_id = "ami-0c94855ba95c574c8"
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

    tag_specifications{
        resource_type = "instance"

        tags = {
            Name = "iu-ec2-instance"

        }
    }
    metadata_options{
        http_endpoint          = "enabled"
        http_tokens            = "required"
        http_put_response_hop_limit = 1
    }
}
