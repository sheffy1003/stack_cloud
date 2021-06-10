/*
variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

*/
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "ZONE_ID" {
  type =  string
  default = "Z09826981WX4BYLYECE52"
}

variable "mysubnet_id" {
  type = map(string)
  default = {
    "us-east-1a" = "subnet-b21974ed"
    "us-east-1b" = "subnet-d5dabbb3"
    "us-east-1c" = "subnet-2ca6c90d"
    "us-east-1d" = "subnet-0f4c7c42"
    "us-east-1e" = "subnet-ad9b2f9c"
    "us-east-1f" = "subnet-3c144e32"
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
  type = map(string)
  default =  { 
    "zone_a" = "us-east-1a"
    "zone-b" = "us_east_1b"
  }
}


variable "PATH_TO_PRIVATE_KEY" {
  default = "MYLAMPKey"
  sensitive = true
}

variable "directory" {
  default = "/var/www/html"
  
}


variable "DATABASE_NAME" {
  type = string
  default = "wordpressdb"
}

variable "DATABASE_USER" {
  type = string
  default ="wordpressuser"
}
/*
variable "DATABASE_PASSWORD" {}
*/
variable "PATH_TO_PUBLIC_KEY" {
  default = "terra-key.pub"
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

