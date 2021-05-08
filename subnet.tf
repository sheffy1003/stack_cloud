

#create VPC
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "clixxVPC"
  }
}

#create subnet in AZ1
resource "aws_subnet" "main1" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1a"
  for_each = {
      "pubsub1"      = "10.0.0.0/23"
      "pvsubapp1"    = "10.0.4.0/23"
      "pvsuboracle1" = "10.0.8.0/23"
      "pvsubrds1"    = "10.0.12.0/22"
  }
  cidr_block = each.value
  tags = {
      Name = each.key
 }
}


#create subnet in AZ2
resource "aws_subnet" "main2" {
  vpc_id     = aws_vpc.main.id
  availability_zone = "us-east-1b"
  for_each = {
      "pubsub2"      = "10.0.2.0/23"
      "pvsubapp2"    = "10.0.6.0/23"
      "pvsuboracle2" = "10.0.10.0/23"
      "pvsubrds2"    = "10.0.16.0/22"
  }
  cidr_block = each.value
  tags = {
      Name = each.key
  }
}





