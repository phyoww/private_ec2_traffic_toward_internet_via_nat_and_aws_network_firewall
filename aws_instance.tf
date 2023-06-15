resource "aws_instance" "ec2jumphost" {
  instance_type = "t2.micro"
  ami = "ami-03e312c9b09e29831" 
  subnet_id = aws_subnet.nat_gateway.id
  security_groups = [aws_security_group.securitygroup.id]
  associate_public_ip_address = true  
  key_name = "testkeypair"
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "CloudideastarMachineJumphost"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("/Users/xxxxxx/testkeypair.pem")
    host = aws_instance.ec2jumphost.public_ip
  }

  # Code for installing the softwares!
  provisioner "remote-exec" {
    inline = [
        "sudo yum update -y",
        "sudo yum install php php-mysqlnd httpd -y",
        "wget https://wordpress.org/wordpress-4.8.14.tar.gz",
        "tar -xzf wordpress-4.8.14.tar.gz",
        "sudo cp -r wordpress /var/www/html/",
        "sudo chown -R apache.apache /var/www/html/",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd",
        "sudo systemctl restart httpd"
    ]
  }      
}

resource "aws_eip" "jumphost" {
  instance = aws_instance.ec2jumphost.id
#  vpc = true
}

output "jumphost_ip" {
  value = aws_eip.jumphost.public_ip
}
