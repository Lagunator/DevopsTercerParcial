provider "aws" {
  region = "us-east-1"
}

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
  ami           = "ami-0453ec754f44f9a4a"  
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              # Instalar Docker y Docker Compose
              sudo yum update -y
              sudo yum install -y docker
              sudo yum install -y python3
              sudo pip3 install docker-compose
              sudo service docker start
              sudo usermod -aG docker ec2-user

              # Clonar el repositorio que contiene docker-compose.yml
              git clone https://github.com/Lagunator/DevopsFinalTest.git /home/ec2-user/taskmanager

              # Ir al directorio y ejecutar Docker Compose
              cd /home/ec2-user/taskmanager
              sudo docker-compose up -d

              # Instalar Nginx (si es necesario para el proxy reverso)
              sudo yum install -y nginx
              sudo service nginx start
              sudo bash -c 'echo "server {
                  listen 80;
                  location / {
                    proxy_pass http://localhost:3000;
                    proxy_set_header Host \$host;
                    proxy_set_header X-Real-IP \$remote_addr;
                    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                    proxy_set_header X-Forwarded-Proto \$scheme;
                  }
                }" > /etc/nginx/conf.d/default.conf'
              sudo service nginx restart
              EOF

              

  tags = {
    Name = "taskmanager-ec2"
  }
}

terraform {
 backend "s3" {
   bucket         = "deployfinaltest"
   key            = "global/s3/terraform.tfstate"
   region         = "us-east-1"
   dynamodb_table = "deployfinaltest"
   encrypt        = true
 }
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}
