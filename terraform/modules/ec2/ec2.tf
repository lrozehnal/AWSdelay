resource "aws_security_group" "SG" {
  provider = aws
  vpc_id   = var.vpc_id
  tags = merge(var.tags, {
    Name = "EC2 SG"
  })

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict!                                                                                                                                                                                                                                                                               
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict!                                                                                                                                                                                                                                                                               
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "key" {
  provider   = aws
  key_name   = var.key_name
  public_key = var.public_key
  tags = merge(var.tags, {
    Name = "EC2 key for AWSdelay"
  })
}

data "aws_ami" "ami" {
  provider    = aws
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.*-arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2" {
  provider                    = aws
  ami                         = data.aws_ami.ami.id
  instance_type               = "t4g.nano"
  subnet_id                   = var.subnets_id[0]
  vpc_security_group_ids      = [aws_security_group.SG.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = merge(var.tags, {
    Name = var.name
  })
}

data "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "ec2" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.name}.${var.domain}."
  type    = "A"
  ttl     = 300
  records = [aws_instance.ec2.public_ip]  
}



