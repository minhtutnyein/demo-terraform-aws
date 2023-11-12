output "mhn-master-vpc-output-id" {
    value = data.aws_vpc.mhn-master-nonprod-vpc.id
}

output "mhn-master-publicSubnet1-id" {
    value = data.aws_subnet.publicSubnet1.id
}

output "mhn-master-privateSubnet2-id" {
    value = data.aws_subnet.privateSubnet2.id
}

output "mhn-master-privateSubnet3-id" {
    value = data.aws_subnet.privateSubnet3.id
}

output "mhn-master-nonprodIgw-id" {
    value = data.aws_internet_gateway.nonprod-Igw.id
}