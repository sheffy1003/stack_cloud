variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}


variable "AWS_REGION" {
  default = "us-east-1"
}

variable "mysubnet_id" {
  type = map(string)
  default = {
    "us-east-1a" = "subnet-b21974ed"
    "us-east-1b" = "subnet-d5dabbb3"
    "us-east-1c" = "subnet-2ca6c90d"
  }
}

variable "SECURITY_GROUP" {
  default = "sg-090e31495f908415e"
}


variable "PATH_TO_PRIVATE_KEY" {
  default = "MYLAMPKey"
  sensitive = true
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
