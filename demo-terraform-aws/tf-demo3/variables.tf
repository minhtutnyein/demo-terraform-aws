variable "mhn-master-nonprod-vpc-id" {
    default                 = "vpc-016afbfb864dfd957"
    type                    = string
}

variable "mhn-master-publicSubnet1-id" {
    default                 = "subnet-0e6773712b4050eda"
    type                    = string
}

variable "mhn-master-privateSubnet2-id" {
    default                 = "subnet-09124f48d3ae00af9"
    type                    = string
}

variable "mhn-master-privateSubnet3-id" {
    default                 = "subnet-05211354acfb51401"
    type                    = string
}

variable "AmazonLinuxImage-id" {
    default                 = "ami-079cd5448deeace01"
    type                    = string 
}

variable "ubuntu-image-id" {
    default                 = "ami-0d52744d6551d851e"
    type                    = string 
}