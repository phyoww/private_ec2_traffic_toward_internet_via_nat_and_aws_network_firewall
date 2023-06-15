resource "aws_security_group" "securitygroup" {
  name = "CloudideastarSecurityGroup"
  description = "CloudideastarSecurityGroup"
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
    ingress {
    description = "Allow all ICMP - IPv4 traffic"  
    cidr_blocks = ["0.0.0.0/0"]
    from_port = -1
    to_port = -1
    protocol = "icmp"
  }
    ingress {
    description = "Allow HTTP "  
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "CloudideastarSecurityGroup"
  }
}

resource "aws_instance" "ec2instance" {
  instance_type = "t2.micro"
  ami = "ami-03e312c9b09e29831" 
  subnet_id = aws_subnet.instance.id
  security_groups = [aws_security_group.securitygroup.id]
  key_name = "testkeypair"
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "CloudideastarMachine"
  }
}

output "instance_private_ip" {
  value = aws_instance.ec2instance.private_ip
}
