
#CREATE A FILE SYSTEM#####
resource "aws_efs_file_system" "efs" {
  encrypted = true
  throughput_mode= "bursting"
  tags = {
    Name = "terraform-filesystem"
  }
}

#CREATE MOUNT TARGET 1 ######
resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.main1["pvsubapp1"].id
  security_groups=[aws_security_group.appgroup.id]
}

#CREATE MOUNT TARGET 2 ######
resource "aws_efs_mount_target" "alpha2" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.main2["pvsubapp2"].id
  security_groups=[aws_security_group.appgroup.id]
}
/*
#CREATE MOUNT TARGET 3 ######
resource "aws_efs_mount_target" "alpha3" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.mysubnet_id["us-east-1c"]
  security_groups=[aws_security_group.appgroup.id]
}

#CREATE MOUNT TARGET 4 ######
resource "aws_efs_mount_target" "alpha4" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.mysubnet_id["us-east-1d"]
  security_groups=[aws_security_group.appgroup.id]
}

#CREATE MOUNT TARGET 5 ######
resource "aws_efs_mount_target" "alpha5" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.mysubnet_id["us-east-1e"]
  security_groups=[aws_security_group.appgroup.id]
}

#CREATE MOUNT TARGET 6 ######
resource "aws_efs_mount_target" "alpha6" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.mysubnet_id["us-east-1f"]
  security_groups=[aws_security_group.appgroup.id]
}

*/