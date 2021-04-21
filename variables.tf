variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}


variable "AWS_REGION" {
  default = "us-east-1"
}

variable "mysubnet_id" {
  type = map(string)
  default = {
    "us-east-1a" = "subnet-2280f17d"
    "us-east-1b" = "subnet-73aade15"
    "us-east-1c" = "subnet-76126057"
    "us-east-1d" = "subnet-00898d4d"
    "us-east-1e" = "subnet-aefe459f"
    "us-east-1f" = "subnet-93c0ee9d"
  }
}
variable "ebs_name" {
  default = {
    ebs_1 = "/dev/sdb"
    ebs_2 = "/dev/sdc"
    ebs_3 = "/dev/sdd"
  } 
}

variable "AZ_ZONE" {
  default = "us-east-1a"
}
variable "RDS_ENDPOINT"  {}

variable "DATABASE_NAME" {}

variable "DATABASE_USER" {}

variable "DATABASE_PASSWORD" {}

variable "PATH_TO_PRIVATE_KEY" {
  default = "wordpresskey"
  sensitive = true
}

variable "directory" {
  default = "/var/www/html"
  
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
   # us-east-1 = "ami-13be557e"
    "us-east-1" = "ami-0742b4e673072066f"
    "us-west-2" = "ami-06b94666"
    "eu-west-1" = "ami-844e0bf7"
  }
}

 #variable "RDS_PASSWORD" {
 #}

#variable "INSTANCE_USERNAME" {
#}
