# THIS SCRIPT AUTOMATES THE FOLLOWING:
# CREATES AN EFS FILE SYSTEM
# Create mount target
# ATTACH MOUNT POINT TO AN EC2 INSTANCE#####
# CREATE AN EC2 INSTANCE AND ATTACH INSTANCE PROFILE
# RUN A BOOTSTRAP SCRIPT TO DEPLOY WORDPRESS APPLICATION ON AN EC2 INSTANCE
# CREATE LAUNCH CONFIGURATION
# CREATE AUTO-SCALING GROUP

/*
#CREATE EC2 INSTANCE
resource "aws_instance" "web" {
  #count = 2
  ami      = var.AMIS["us-east-1"]
  instance_type = "t2.micro"
  availability_zone="us-east-1d"
  iam_instance_profile = aws_iam_instance_profile.S3profile.name
  vpc_security_group_ids =[aws_security_group.security_grp.id]
  key_name      = var.PATH_TO_PRIVATE_KEY
  user_data      = templatefile("bootstrap.sh", {
    efs_id      = aws_efs_file_system.efs.id,
    REGION      = var.AWS_REGION,
    MOUNT_POINT = var.directory,
    DB_NAME     = var.DATABASE_NAME,  
    DB_USER     = var.DATABASE_USER,
    DB_PASSWORD = var.DATABASE_PASSWORD,
    RDS_ENDPOINT= var.RDS_ENDPOINT
    })
 depends_on = [
    aws_efs_mount_target.alpha,
    aws_efs_mount_target.alpha2,
    aws_efs_mount_target.alpha3,
    aws_efs_mount_target.alpha4,
    aws_efs_mount_target.alpha5,
    aws_efs_mount_target.alpha6,
    #aws_db_instance.rds
    ] 
  tags = {
    Name = "WORDPRESS-SERVER1"
  }
}

*/
#CREATE LAUNCH CONFIGURATION
resource "aws_launch_configuration" "config" {
  name          = "ASG_TERRAFORM_config1"
  image_id      = var.AMIS["us-east-1"]
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.S3profile.name
  security_groups =[aws_security_group.security_grp.id]
  key_name      = aws_key_pair.key.key_name
  user_data      = templatefile("boot.tpl", {
    efs_id      = aws_efs_file_system.efs.id,
    REGION      = var.AWS_REGION,
    DB_NAME     = "stack-wordpress-db3",
    DB_USER     = "wordpress-user",
    DB_PASSWORD = "stackinc",
    #RDS_ENDPOINT= var.RDS_ENDPOINT,
    #MOUNT_POINT = var.directory 
    })
  depends_on = [
    aws_efs_mount_target.alpha,
    aws_efs_mount_target.alpha2,
    aws_efs_mount_target.alpha3,
    aws_efs_mount_target.alpha4,
    aws_efs_mount_target.alpha5,
    aws_efs_mount_target.alpha6,
    #aws_db_instance.rds
    ] 
}

#CREATE AN AUTO-SCALING GROUP
resource "aws_autoscaling_group" "firstgrp" {
  name                 = "ASG_STACKTEST_GR0UP1"
  launch_configuration = aws_launch_configuration.config.name
  min_size             = 1
  max_size             = 1
  desired_capacity = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  vpc_zone_identifier  =[
      var.mysubnet_id["us-east-1a"],
      var.mysubnet_id["us-east-1b"],
      var.mysubnet_id["us-east-1c"]
      ]
  tag {
    key                 = "Name"
    value               = "ASG-terra-instance1"
    propagate_at_launch = true
  }
  depends_on = [aws_efs_mount_target.alpha]
}

#CREATE AUTO-SCALING POLICY
resource "aws_autoscaling_policy" "policy" {
  name                   = "ASG_STACKTEST_POLICY1"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 30 
  autoscaling_group_name = aws_autoscaling_group.firstgrp.name
  depends_on = [aws_efs_mount_target.alpha]
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}

#Create Key pair
resource "aws_key_pair" "key" {
  key_name   = "myec2key"
  public_key = file("terraform_key.pub")
}


