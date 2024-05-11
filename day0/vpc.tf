# main.tf

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name = "student-${var.prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a"]
  private_subnets = ["10.0.2.0/24"]
  public_subnets  = ["10.0.0.0/24"]

  enable_nat_gateway = true
}
resource "aws_eip" "f5" {
  instance = aws_instance.f5.id
  domain   = "vpc"
}
resource "aws_security_group" "f5" {
  name        = "${var.prefix}-f5"
  description = "Allow inbound SSH and HTTPS traffic from my IP"
  vpc_id      = module.vpc.vpc_id # Specify the VPC ID here
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"] # Replace with your laptop's public IP
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nginx" {
  name   = "student-${var.prefix}-nginx"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
