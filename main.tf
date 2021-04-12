# THIS SCRIPT AUTOMATES THE FOLLOWING:
# CREATES AN EFS FILE SYSTEM
# CREATES A MOUNT TARGET
# ATTACH MOUNT POINT TO AN EC2 INSTANCE#####
# CREATE A ROLE WITH S3 FULL ACCESS
# CREATE AN INSTANCE PROFILE AND ATTACH ROLE
# CREATE AN EC2 INSTANCE AND ATTACH INSTANCE PROFILE
# RUN A BOOTSTRAP SCRIPT TO DEPLOY WORDPRESS APPLICATION ON AN EC2 INSTANCE
# CREATE LAUNCH CONFIGURATION
# CREATE AUTO-SCALING POLICY
# CREATE AUTO-SCALING GROUP


#CREATE A FILE SYSTEM#####
resource "aws_efs_file_system" "efs" {
  encrypted = true
  throughput_mode= "bursting"
  tags = {
    Name = "terraform-filesystem"
  }
}
/*
#CREATE MOUNT TARGET######
resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.mysubnet_id["us-east-1a"]
  security_groups=[var.SECURITY_GROUP]
}

#CREATE INSTANCE AND RUN BOOTSTRAP SCRIPT#####
resource "aws_instance" "web" {
  #count = 2
  ami            = var.AMIS["us-east-1"]
  instance_type  = "t2.micro"
  subnet_id      = var.mysubnet_id["us-east-1a"]
  iam_instance_profile = aws_iam_instance_profile.S3profile.name
  depends_on = [aws_efs_mount_target.alpha]
  user_data      = templatefile("bootstrap.sh", {
    efs_id = aws_efs_file_system.efs.id,
    REGION = var.AWS_REGION,
    MOUNT_POINT = "/var/www/html" })
  key_name       = var.PATH_TO_PRIVATE_KEY
  vpc_security_group_ids = [var.SECURITY_GROUP]
  tags = {
    Name = "wpinst-terraformserver"
  }
}

#CREATE AN IAM ROLE FOR EC2 INSTANCE
resource "aws_iam_role" "S3role" {
  name = "S3_TERRAFORM_ACCESS_ROLE"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Dev = "Stack"
  }
}

#CREATE S3 FULL ACCESS POLICY
resource "aws_iam_policy" "policy" {
  name        = "s3-access-policy"
  description = "Grants access to S3 resources"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                      "s3:GetObject",
                      "s3:ListObject"
                      ],
            "Resource": "*"
        }
    ]
  })
}

#ATTACH POLICY TO ROLE
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.S3role.name
  policy_arn = aws_iam_policy.policy.arn
}

#CREATE AN INSTANCE PROFILE
#ATTACH ROLE TO PROFILE
resource "aws_iam_instance_profile" "S3profile" {
  name  = "MY_S3_profile"
  role = aws_iam_role.S3role.name
}


#CREATE LAUNCH CONFIGURATION
resource "aws_launch_configuration" "config" {
  name          = "ASG_TERRAFORM_config"
  image_id      = var.AMIS["us-east-1"]
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.S3profile.name
  security_groups =[var.SECURITY_GROUP]
  key_name      = var.PATH_TO_PRIVATE_KEY
  user_data      = templatefile("bootstrap.sh", {
    efs_id = aws_efs_file_system.efs.id,
    REGION = var.AWS_REGION,
    MOUNT_POINT = "/var/www/html" })
  depends_on = [aws_efs_mount_target.alpha]
  
}

#CREATE AN AUTO-SCALING GROUP
resource "aws_autoscaling_group" "firstgrp" {
  name                 = "ASG_STACKTEST_GRP"
  launch_configuration = aws_launch_configuration.config.name
  min_size             = 1
  max_size             = 2
  desired_capacity = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier  =[
      var.mysubnet_id["us-east-1a"],
      var.mysubnet_id["us-east-1b"],
      var.mysubnet_id["us-east-1c"]
      ]
  tag {
    key                 = "Name"
    value               = "ASG-instance"
    propagate_at_launch = true
  }
  depends_on = [aws_efs_mount_target.alpha]
}

#CREATE AUTO-SCALING POLICY
resource "aws_autoscaling_policy" "policy" {
  name                   = "ASG_STACKTEST_POLICY"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 300 
  autoscaling_group_name = aws_autoscaling_group.firstgrp.name
  depends_on = [aws_efs_mount_target.alpha]
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}

#DISPLAY INSTANCE PUBLIC IP ADDRESS
output "public_ip_address" {
  value = aws_instance.web.public_ip
}


#DISPLAY FILE SYSTEM ID
output "FILE_SYSTEM_ID" {
  value = aws_efs_file_system.efs.id
}

#DISPLAY MOUNT TARGET DNS NAME
output "mount_target_dns" {
  value = aws_efs_file_system.efs.dns_name
}



#using provisoner to run scripts on instance from a file
resource "null_resources" "web2" {
  provisioner "file" {
    source      = "boot_efs.sh"
    destination = "/tmp/boot_efs.sh"
  }
  #using provisioner with inline arguments to execute scripts remotely on instance
  provisioner "remote-exec" {
    inline = [
      "chmod 755 /tmp/boot_efs.sh",
      "/tmp/script.sh",
    ]
  }
}



# using provisioner to run commands on the local operating system(e.g AWS CLI command)
resource "null_resource" "efs1" {
  provisioner "local-exec" {
    command ="aws efs create-file-system --performance-mode generalPurpose --throughput-mode bursting --encrypted --tags Key=Name,Value=stack-file-system2 --profile admin_sheriff"
  }
}
*/



