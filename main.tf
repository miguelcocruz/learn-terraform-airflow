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
    cidr_blocks = [var.ip_address]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [var.ip_address]
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
  instance_type = "t2.large"

  # You can use a key pair to securely connect to your instance.
  # Ensure that you have access to the selected key pair before you launch the instance.
  key_name        = aws_key_pair.this.key_name
  security_groups = [aws_security_group.this.name]

  
  iam_instance_profile = aws_iam_instance_profile.example.name


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

    git clone https://github.com/miguelcocruz/learn-terraform-airflow.git

    #cd learn-terraform-airflow

    #sudo docker compose up -d

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







# IAM Policies


# "Assume role policy" which is an IAM Policy that defines who can assume a given IAM role
# 1. Define who can assume a given IAM Role
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# 2. Define IAM role (and attach the assume role policy)
resource "aws_iam_role" "instance" {
  name_prefix = "CustomS3Role3"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# 3. Define permissions
data "aws_iam_policy_document" "s3_admin_permissions" {
  statement {
    effect = "Allow"
    actions = ["s3:*"]
    resources = ["*"]
  }
}

# 4. Attach permissions to IAM role
resource "aws_iam_role_policy" "example" {
  role = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.s3_admin_permissions.json
}

resource "aws_iam_instance_profile" "example" {
  role = aws_iam_role.instance.name
}



# S3 bucket

resource "aws_s3_bucket" "this" {
  bucket = "mglvlm-20230121"
  force_destroy = true
}