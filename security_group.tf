#create security group for RDS using port 3306
#reference security group in RDS instance resource
#Remember to allow traffic from EC2 INSTANCE group into RDS security group

resource "aws_security_group" "security_grp" {
  name        = "TERRAFORM-DMZ"
  description = "Allow TLS inbound traffic"


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "MYSQL/AURORA"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "securegroup"
  }
}

# This rule allows ec2 instance to connect to rds_security_group
resource "aws_security_group_rule" "MYSQL_AURORA" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = "sg-04eac2561c497c2d2"
  source_security_group_id=aws_security_group.security_grp.id
}

