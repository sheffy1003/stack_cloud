#create Bastion Server host
resource "aws_instance" "web" {
  ami      = var.AMIS["us-east-1"]
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main1["pubsub1"].id
  iam_instance_profile = aws_iam_instance_profile.S3profile.name
  vpc_security_group_ids =[aws_security_group.public.id]
  key_name      = aws_key_pair.key.key_name
  depends_on = [
    aws_efs_mount_target.alpha,
    aws_efs_mount_target.alpha2,
    aws_db_instance.wordpressdblixx
    ] 
  tags = {
    Name = "Bastion-host"
  }
}

# data source for packer ami
data "aws_ami" "stack" {
  owners     = ["self"]
  filter {
    name   = "name"
    values = ["ami-stack-1.0"]
  }
}
#within your ASG, replace image_id with below:
#image_id=data.aws_ami.stack.id

#CREATE CLIXX LAUNCH CONFIGURATION
resource "aws_launch_configuration" "config" {
  name          = "ASG_TERRAFORM_config1"
  #image_id      = var.AMIS["us-east-1"]
  image_id= data.aws_ami.stack.id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.S3profile.name
  security_groups =[aws_security_group.appgroup.id]
  key_name      = aws_key_pair.key.key_name
  user_data      = templatefile("bootstrap.sh", {
    efs_id      = aws_efs_file_system.efs.id,
    REGION      = var.AWS_REGION,
    MOUNT_POINT = var.directory,
    DB_NAME     = var.DATABASE_NAME,  
    DB_USER     = local.db_creds.username,
    DB_PASSWORD = local.db_creds.password,
    DB_HOST     = aws_db_instance.wordpressdblixx.address,
    LB_DNS      = aws_lb.alb.dns_name
    })
  depends_on = [
    aws_db_instance.wordpressdblixx
    ] 
}


#CREATE AN AUTO-SCALING GROUP for CLIXX APP
resource "aws_autoscaling_group" "firstgrp" {
  name                 = "ASG_STACKTEST_GR0UP1"
  launch_configuration = aws_launch_configuration.config.name
  min_size             = 2
  max_size             = 3
  desired_capacity = 2
  health_check_grace_period = 30
  health_check_type         = "EC2"
  target_group_arns    = [aws_lb_target_group.target.arn]
  vpc_zone_identifier  = [
      aws_subnet.main1["pvsubapp1"].id,
      aws_subnet.main2["pvsubapp2"].id
      ]
  tag {
    key                 = "Name"
    value               = "ASG-terra-instance1"
    propagate_at_launch = true
  }
  depends_on = [aws_efs_mount_target.alpha,aws_efs_mount_target.alpha2]
}



# Application load balancer
resource "aws_lb" "alb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    =  [aws_security_group.public.id]
  subnets            = [aws_subnet.main1["pubsub1"].id,aws_subnet.main2["pubsub2"].id]
  enable_deletion_protection = false
  tags = {
    Environment = "terra-alb"
  }
}

# ALB target group
resource "aws_lb_target_group" "target" {
  name     = "tf-alb-group"
  port     = 80
  protocol = "HTTP"
  health_check {
    path = "/index.php"  
  }
  vpc_id   = aws_vpc.main.id
  depends_on = [aws_vpc.main]
}

# ALB listener resource
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
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


#Create a keypair
resource "aws_key_pair" "key" {
  key_name   = "terraform-ebs-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

/*
data "aws_secretsmanager_secret_version" "creds1" {
  # Fill in the name you gave to your secret
  secret_id = "creds"
}


locals {
  db_creds1 = jsondecode(
    data.aws_secretsmanager_secret_version.creds1.secret_string
  )
}
*/