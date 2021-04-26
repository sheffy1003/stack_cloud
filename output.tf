/*
#DISPLAY PUBLIC IP ADDRESS
output "public_ip_address" {
  value = aws_instance.web.public_ip
}
*/

#DISPLAY FILE SYSTEM ID
output "FILE_SYSTEM_ID" {
  value = aws_efs_file_system.efs.id
}

#DISPLAY MOUNT TARGET DNS NAME
output "mount_target_dns" {
  value = aws_efs_file_system.efs.dns_name
}
