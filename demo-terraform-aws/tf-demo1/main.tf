data "aws_vpc" "mhn-master-nonprod-vpc" { 
    provider = aws.mhn-master-admin
    filter {
        name = "tag:Name"
        values = ["mhn-master-nonprod-vpc"]
    }
}

data "aws_subnet" "publicSubnet1" {
    provider = aws.mhn-master-admin 
    filter {
        name = "tag:Name"
        values = ["publicSubnet1"]
    }
}

data "aws_subnet" "privateSubnet2" {
    provider = aws.mhn-master-admin 
    filter {
        name = "tag:Name"
        values = ["privateSubnet2"]
    }
}

data "aws_subnet" "privateSubnet3" {
    provider = aws.mhn-master-admin 
    filter {
        name = "tag:Name"
        values = ["privateSubnet3"]
    }
}

data "aws_internet_gateway" "nonprod-Igw" {
  provider = aws.mhn-master-admin 
  filter {
    name   = "tag:Name"
    values = ["mhn-master-nonprodIgw"]
  }
}