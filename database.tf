
#restore RDS DataBase from snapshot

resource "aws_db_instance" "wordpressdblixx" {
  instance_class       = "db.t2.micro"
  snapshot_identifier  = "clixxdbsnap"
  identifier           = "wordpressdbclixx"
  username             =local.db_creds.username
  password             =local.db_creds.password
  db_subnet_group_name = aws_db_subnet_group.subnetgroup.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.rdsgroup.id]
}



# Create DB Subnet Group
resource "aws_db_subnet_group" "subnetgroup" {
  name       = "terra_db_group"
  subnet_ids = [aws_subnet.main1["pvsubrds1"].id, aws_subnet.main2["pvsubrds2"].id]
  tags = {
    Name = "db_group"
  }
}

/*
data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = "creds"
}


locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}
*/

data "aws_kms_secrets" "creds" {
  secret {
    name    = "db"
    payload = file("${path.module}/creds.yml.encrypted")
  }
}

locals {
  db_creds = yamldecode(data.aws_kms_secrets.creds.plaintext["db"])
}
