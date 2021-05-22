
# create route table for private subnet
resource "aws_route_table" "main_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "main-private"
  }
}


# create route table for public subnet
resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "main-public"
  }
}


#create internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main"
  }
}

# create elastic ip address
resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.gw]
  vpc      = true
}


resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.gw]
  vpc      = true
}


resource "aws_eip" "inst_ip" {
  instance = aws_instance.web.id
  vpc      = true
  depends_on = [aws_internet_gateway.gw]
}

#create NAT gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main1["pubsub1"].id
  tags = {
    Name = "NAT_gw"
  }
}

#associate public route table with main-public subnet
resource "aws_route_table_association" "attach_pub" {
  for_each = {
    "sub1" = aws_subnet.main1["pubsub1"].id
    "sub2" = aws_subnet.main2["pubsub2"].id
      }
  subnet_id      = each.value
  route_table_id = aws_route_table.main_public.id
}


#associate private route table with main-private subnet
resource "aws_route_table_association" "attach_private" {
  for_each = {
    "sub3" = aws_subnet.main1["pvsuboracle1"].id
    "sub4" = aws_subnet.main2["pvsuboracle2"].id
    "sub5" = aws_subnet.main1["pvsubrds1"].id
    "sub6" = aws_subnet.main2["pvsubrds2"].id
    "sub7" = aws_subnet.main1["pvsubapp1"].id
    "sub8" = aws_subnet.main2["pvsubapp2"].id
      }
  subnet_id      = each.value
  route_table_id = aws_route_table.main_private.id
}

#Route 53 DNS 
# data source for route53 hosted zone
data "aws_route53_zone" "selected" {
  #zone_id      = "Z09826981WX4BYLYECE52"
  name         = "sheffcloud.com"
  private_zone = true
  vpc_id       = aws_vpc.main.id
}

# Create A record with simple routing policy for DNS
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${data.aws_route53_zone.selected.name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}



