resource "aws_vpc" "mhn-master-nonprod-vpc" {
  cidr_block                    = "192.168.0.0/16"
  enable_dns_hostnames          = true
  enable_dns_support            = true
  instance_tenancy              = "default"
  provider                      = aws.mhn-master-admin

  tags          = {
    Name        = "mhn-master-nonprod-vpc"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_subnet" "publicSubnet1" {
  provider                       = aws.mhn-master-admin
  vpc_id                         = aws_vpc.mhn-master-nonprod-vpc.id
  cidr_block                     = "192.168.1.0/24"
  map_public_ip_on_launch        = true
  availability_zone              = "ap-northeast-1a"
  
  tags          = {
    Name        = "publicSubnet1"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_subnet" "publicSubnet2" {
  provider                        = aws.mhn-master-admin
  vpc_id                          = aws_vpc.mhn-master-nonprod-vpc.id
  cidr_block                      = "192.168.2.0/24"
  map_public_ip_on_launch         = true
  availability_zone               = "ap-northeast-1c"

  tags          = {
    Name        = "publicSubnet2"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_subnet" "publicSubnet3" {
  provider                        = aws.mhn-master-admin
  vpc_id                          = aws_vpc.mhn-master-nonprod-vpc.id
  cidr_block                      = "192.168.3.0/24"
  map_public_ip_on_launch         = true
  availability_zone               = "ap-northeast-1d"

  tags          = {
    Name        = "publicSubnet3"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_internet_gateway" "mhn-master-nonprodIgw" {
  provider                        = aws.mhn-master-admin
  #vpc_id                         = aws_vpc.mhn-master-nonprod-vpc.id

  tags          = {
    Name        = "mhn-master-nonprodIgw"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_internet_gateway_attachment" "vpcGatewayAttachment" {
  provider                        = aws.mhn-master-admin
  internet_gateway_id             = aws_internet_gateway.mhn-master-nonprodIgw.id
  vpc_id                          = aws_vpc.mhn-master-nonprod-vpc.id 
}

resource "aws_route" "mhn-master-Igw-defaultRoute" {
  provider                        = aws.mhn-master-admin 
  route_table_id                  = "rtb-015fd6555f31c2041"
  gateway_id                      = aws_internet_gateway.mhn-master-nonprodIgw.id
  destination_cidr_block          = "0.0.0.0/0"
}

resource "aws_subnet" "privateSubnet1" {
  provider                       = aws.mhn-master-admin
  vpc_id                         = aws_vpc.mhn-master-nonprod-vpc.id
  cidr_block                     = "192.168.4.0/24"
  map_public_ip_on_launch        = false 
  availability_zone              = "ap-northeast-1a"
  
  tags          = {
    Name        = "privateSubnet1"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_subnet" "privateSubnet2" {
  provider                       = aws.mhn-master-admin
  vpc_id                         = aws_vpc.mhn-master-nonprod-vpc.id
  cidr_block                     = "192.168.5.0/24"
  map_public_ip_on_launch        = false 
  availability_zone              = "ap-northeast-1c"
  
  tags          = {
    Name        = "privateSubnet2"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_subnet" "privateSubnet3" {
  provider                       = aws.mhn-master-admin
  vpc_id                         = aws_vpc.mhn-master-nonprod-vpc.id
  cidr_block                     = "192.168.6.0/24"
  map_public_ip_on_launch        = false 
  availability_zone              = "ap-northeast-1d"
  
  tags          = {
    Name        = "privateSubnet3"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_route_table" "privaterouteTable1" {
  provider                       = aws.mhn-master-admin
  vpc_id                         = aws_vpc.mhn-master-nonprod-vpc.id

  route {
    cidr_block                   = "192.168.0.0/16"
    gateway_id                   = "local"
  }

  tags          = {
    Name        = "privaterouteTable1"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_route_table" "privaterouteTable2" {
  provider                       = aws.mhn-master-admin
  vpc_id                         = aws_vpc.mhn-master-nonprod-vpc.id

  route {
    cidr_block                   = "192.168.0.0/16"
    gateway_id                   = "local"
  }

  tags          = {
    Name        = "privaterouteTable2"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_route_table" "privaterouteTable3" {
  provider                       = aws.mhn-master-admin
  vpc_id                         = aws_vpc.mhn-master-nonprod-vpc.id

  route {
    cidr_block                   = "192.168.0.0/16"
    gateway_id                   = "local"
  }

  tags          = {
    Name        = "privaterouteTable3"
    Region      = "Tokyo"
    Env         = "Non-prod"
  }
}

resource "aws_route_table_association" "privateSubnetToRT1" {
  provider                       = aws.mhn-master-admin
  subnet_id                      = aws_subnet.privateSubnet1.id
  route_table_id                 = aws_route_table.privaterouteTable1.id
}

resource "aws_route_table_association" "privateSubnetToRT2" {
  provider                       = aws.mhn-master-admin
  subnet_id                      = aws_subnet.privateSubnet2.id
  route_table_id                 = aws_route_table.privaterouteTable2.id
}

resource "aws_route_table_association" "privateSubnetToRT3" {
  provider                       = aws.mhn-master-admin
  subnet_id                      = aws_subnet.privateSubnet3.id
  route_table_id                 = aws_route_table.privaterouteTable3.id
}

resource "aws_eip" "natGatewayEIP1" {
  provider                       = aws.mhn-master-admin
  domain                         = "vpc"
  public_ipv4_pool               = "amazon"

    tags          = {
    Name          = "natGatewayEIP1"
    Region        = "Tokyo"
    Env           = "Non-prod"
  }
}

resource "aws_nat_gateway" "natGateway1" {
  provider                       = aws.mhn-master-admin
  allocation_id                  = aws_eip.natGatewayEIP1.id
  subnet_id                      = aws_subnet.publicSubnet1.id
  connectivity_type              = "public"

    tags          = {
    Name          = "natGateway1"
    Region        = "Tokyo"
    Env           = "Non-prod"
  }
}

resource "aws_route" "defaultRouteForPrivateSubnet1" {
  provider                        = aws.mhn-master-admin 
  route_table_id                  = "rtb-0cbe13e90cec5d9f7"
  destination_cidr_block          = "0.0.0.0/0"
  gateway_id                      = aws_nat_gateway.natGateway1.id
}

resource "aws_route" "defaultRouteForPrivateSubnet2" {
  provider                        = aws.mhn-master-admin 
  route_table_id                  = "rtb-09d490546f7bb7036"
  destination_cidr_block          = "0.0.0.0/0"
  gateway_id                      = aws_nat_gateway.natGateway1.id
}

resource "aws_route" "defaultRouteForPrivateSubnet3" {
  provider                        = aws.mhn-master-admin 
  route_table_id                  = "rtb-029478ab8c3e484ba"
  destination_cidr_block          = "0.0.0.0/0"
  gateway_id                      = aws_nat_gateway.natGateway1.id
}