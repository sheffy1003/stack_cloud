#create RDS database 
#create RDS instance
resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "terraform-rds-instance"
  name                 = var.DATABASE_NAME
  username             = var.DATABASE_USER
  password             = var.DATABASE_PASSWORD
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.security_grp.id]
}

#create security group for RDS using port 3306
#reference security group in RDS instance resource
#Remember to allow traffic from EC2 INSTANCE group into RDS security group
#name attribute refers to database name
#identifier attribute refers to RDS instance name