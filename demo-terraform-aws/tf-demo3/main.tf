# RSA key of size 4096 bits
resource "tls_private_key" "keygen" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}

resource "aws_key_pair" "mhn-master-keyPair" {
  provider                  = aws.mhn-master-admin
  key_name                  = "mhn-master-admin-jp" # Name for my AWS key pair
  public_key                = tls_private_key.keygen.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.keygen.private_key_pem}' > mhn-master-admin-jp.pem"
  }

    tags          = {
    Name          = "mhn-master-KeyPair"
    Region        = "Tokyo"
    Env           = "Non-prod"
  }
}

resource "aws_security_group" "mgmtAccessToEC2public" { #Create SecurityGroup for mgmtAccess from Public
  provider                  = aws.mhn-master-admin
  name                      = "mgmtAccessToEC2public"
  description               = "Allow SSH and ICMP inbound traffic"
  vpc_id                    = var.mhn-master-nonprod-vpc-id

  ingress {
    description             = "Allow SSH access from Anywhere"
    from_port               = 22
    to_port                 = 22
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  ingress {
    description             = "Allow ICMP  from Anywhere"
    from_port               = -1
    to_port                 = -1
    protocol                = "icmp"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  egress {
    description             = "Anyservices to Anywhere"
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }

    tags          = {
    Name          = "mgmtAccessToEC2public"
    Region        = "Tokyo"
    Env           = "Non-prod"
  }
}

resource "aws_security_group" "controlAccessToEC2private"{ #Create SecurityGroup for mgmtAccess from Public
  provider                  = aws.mhn-master-admin
  name                      = "controlAccessToEC2private"
  description               = "Allow SSH and ICMP inbound traffic"
  vpc_id                    = var.mhn-master-nonprod-vpc-id

  ingress {
    description             = "Allow SSH access from Anywhere"
    from_port               = 22
    to_port                 = 22
    protocol                = "tcp"
    cidr_blocks             = ["192.168.1.0/24"]
  }

  ingress {
    description             = "Allow ICMP  from Anywhere"
    from_port               = -1
    to_port                 = -1
    protocol                = "icmp"
    cidr_blocks             = ["192.168.1.0/24"] 
  }

  egress {
    description             = "Anyservices to Anywhere"
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }

    tags          = {
    Name          = "controlAccessToEC2private"
    Region        = "Tokyo"
    Env           = "Non-prod"
  }
}

resource "aws_instance" "manageNode1" {
  provider                  = aws.mhn-master-admin
  key_name                  = aws_key_pair.mhn-master-keyPair.key_name 
  ami                       = var.AmazonLinuxImage-id
  instance_type             = "t2.micro"
  availability_zone         = "ap-northeast-1a"
  subnet_id                 = var.mhn-master-publicSubnet1-id
  vpc_security_group_ids    = [aws_security_group.mgmtAccessToEC2public.id]

    tags          = {
    Name          = "manageNode1"
    Region        = "Tokyo"
    Env           = "Non-prod"
  }
}

resource "aws_instance" "controlNode1" {
  provider                  = aws.mhn-master-admin
  key_name                  = aws_key_pair.mhn-master-keyPair.key_name 
  ami                       = var.ubuntu-image-id
  instance_type             = "t2.micro"
  availability_zone         = "ap-northeast-1c"
  subnet_id                 = var.mhn-master-privateSubnet2-id
  vpc_security_group_ids    = [aws_security_group.controlAccessToEC2private.id]

    tags          = {
    Name          = "controlNode1"
    Region        = "Tokyo"
    Env           = "Non-prod"
  }
}

resource "aws_instance" "controlNode2" {
  provider                  = aws.mhn-master-admin
  key_name                  = aws_key_pair.mhn-master-keyPair.key_name 
  ami                       = var.ubuntu-image-id
  instance_type             = "t2.micro"
  availability_zone         = "ap-northeast-1d"
  subnet_id                 = var.mhn-master-privateSubnet3-id
  vpc_security_group_ids    = [aws_security_group.controlAccessToEC2private.id]

    tags          = {
    Name          = "controlNode2"
    Region        = "Tokyo"
    Env           = "Non-prod"
  }
}