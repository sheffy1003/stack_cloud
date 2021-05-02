#This script creates RDS MySQL database 
#create RDS instance
resource "aws_db_instance" "rds" {
  instance_class       = "db.t2.micro"
  snapshot_identifier = "clixxdbsnap"
  username             = "wordpressuser"
  password             = "W3lcome123"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.security_grp.id]
}

output "RDS_PASS" {
  value = aws_db_instance.rds.password
}


#create security group for RDS using port 3306
#reference security group in RDS instance resource
#Remember to allow traffic from EC2 INSTANCE group into RDS security group
#name attribute refers to database name
#identifier attribute refers to RDS instance name