#This script creates RDS MySQL database 
#create RDS instance
/*
resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "terraform-rds-instance"
  name                 = "wordpressdb"
  username             = "rdsuser"
  password             = "stackinc2"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.security_grp.id]
}
*/
#create security group for RDS using port 3306
#reference security group in RDS instance resource
#Remember to allow traffic from EC2 INSTANCE group into RDS security group
#name attribute refers to database name
#identifier attribute refers to RDS instance name