provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "this" {
  name = "mgl_sg"

  ingress {
    description = "Inbound"
    from_port   = 22
    to_port     = 22
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

# tls_private_key (Resource) - not an aws resource.
# Creates a PEM (and OpenSSH) formatted private key.
# Used to generate public and private keys for AWS key pair.
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "mgl_ec2_hello_world"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_instance" "this" {
  ami           = "ami-0ff39345bd62c82a5"
  instance_type = "t2.micro"

  # You can use a key pair to securely connect to your instance.
  # Ensure that you have access to the selected key pair before you launch the instance.
  key_name        = aws_key_pair.this.key_name
  security_groups = [aws_security_group.this.name]

  tags = {
    Name = "hello world"
  }

  # Install Docker Engine on Ubuntu
  # https://docs.docker.com/engine/install/ubuntu/
  user_data_replace_on_change = true
  user_data                   = <<-EOT
    #!/bin/bash
    sudo apt-get -y update
    sudo apt-get -y install \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get -y update

    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt-get -y update

    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

  EOT
}

output "ec2_dns_public_name" {
  value = aws_instance.this.public_dns
}

output "public_key" {
  value = tls_private_key.this.public_key_openssh
}

resource "local_file" "this" {
  content  = tls_private_key.this.private_key_pem
  filename = "tf-key-pair.pem"

  # To avoid Error: Unprotected private key file
  # Your private key file must be protected from read and write operations from any other users
  file_permission = "0400"
}