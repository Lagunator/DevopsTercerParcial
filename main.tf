provider "aws" {
  region = "us-east-1"
}

# Resto de los recursos Terraform...
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  key_name = "ec2key"
  security_groups = [aws_security_group.ec2_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y docker.io nginx
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "taskmanager-ec2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}
