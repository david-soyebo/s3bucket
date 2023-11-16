resource "aws_vpc" "vpc_1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = "igw-pub"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "pubsub1"
    
  }

  map_public_ip_on_launch = true  
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "pubsub2"
    
  }

  map_public_ip_on_launch = true  
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "privatesub1"
    
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "privatesub2"
    
}
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}



resource "aws_route_table_association" "pubsub1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "pubsub2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_security_group" "allow_web-traffic" {
  name        = "allow_web-traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc_1.id

  ingress {
    description      = "https from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-0cfd0973db26b893b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet1.id
  tags = {
    Name = "EC2"
  }
}
resource "aws_instance" "ec2-2" {
  ami           = "ami-0cfd0973db26b893b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet2.id
  tags = {
    Name = "EC2"
  }
}


resource "aws_s3_bucket" "s3_bucket_state" {
  bucket = "bucket-state-davids"

  tags = {
    Name        = "bucket-state"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table" "dynamodb_state" {
  name           = "dynamo-state"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"  
  }

  hash_key = "LockID"

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}
