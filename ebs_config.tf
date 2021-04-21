# Create an EC2 instance
# Create an EBS volumes
# Attach EBS volumes to EC2 instance
# Use provisioner to call the disk drive configuration scripts

#CREATE EC2 INSTANCE
resource "aws_instance" "web1" {
  ami      = var.AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  subnet_id      = var.mysubnet_id[var.AZ_ZONE]
  vpc_security_group_ids =[aws_security_group.security_grp.id]
  key_name      = var.PATH_TO_PRIVATE_KEY
  tags = {
    Name = "EBS_MGT_TERRAFORM"
  }
  user_data = file("ebs_bootstrap.sh")
}

#Create EBS volumes
resource "aws_ebs_volume" "ebs" {
  #count = 3
  availability_zone = var.AZ_ZONE
  size              = 8
  #tags = {
    #Name = "EBS_VOL_TERRAFORM"
  #}
  for_each = {
    "vol_1" = "EBS_VOL_TERRAFORM1"
    "vol_2" = "EBS_VOL_TERRAFORM2"
    "vol_3" = "EBS_VOL_TERRAFORM3"
  }
  tags = {
    Name = each.value
  }
}

#EBS volume 1 attachment
resource "aws_volume_attachment" "ebs_att1" {
  device_name = var.ebs_name["ebs_1"]
  volume_id   = aws_ebs_volume.ebs["vol_1"].id
  instance_id = aws_instance.web1.id
  force_detach = true
}

#EBS volume 2 attachment
resource "aws_volume_attachment" "ebs_att2" {
  device_name = var.ebs_name["ebs_2"]
  volume_id   = aws_ebs_volume.ebs["vol_2"].id
  instance_id = aws_instance.web1.id
  force_detach = true  
}

#EBS volume 3 attachment
resource "aws_volume_attachment" "ebs_att3" {
  device_name = var.ebs_name["ebs_3"]
  volume_id   = aws_ebs_volume.ebs["vol_3"].id
  instance_id = aws_instance.web1.id
  force_detach = true
}

output "EC2_public_ip" {
  value = aws_instance.web1.public_ip
}


/*
resource "null_resource" "test" {
  provisioner "file" {
    source      = "ebs_bootstrap.sh"
    destination = "~/ebs_bootstrap.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod 755 ~/ebs_bootstrap.sh",
      "~/ebs_bootstrap.sh",
    ]
  }
  
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("wordpresskey.pem")
    host     = aws_instance.web1.public_ip
    script_path="${path.module}/ebs_bootstrap.sh"
  }
  
}
*/


/*
  for_each = {
    vol_1 = "EBS_VOL_TERRAFORM1"
    vol_2 = "EBS_VOL_TERRAFORM2"
    vol_3 = "EBS_VOL_TERRAFORM3"
  }

  tags = {
    Name = each.value
  }
  */