# s3 bucket (data)
# s3 bucket (logs)
# vpc (private subnet and public subnet)
    # ver se é possível simplificar expor webserver (por exemplo, expor publicamente mas permitir apenas o meu IP)
# airflow metastore (rds)
# airflow scheduler + workers (fargate)
  # substitui fargate por ec2. ec2 parece mais simples
# airflow webserver
# dag storage (efs)


provider "aws" {
  region = "us-east-2"
}


# Data storage
resource "aws_s3_bucket" "data" {
  bucket = "mgl-airflow-data"
  
  tags = {
    "Name" = "Airflow data storage"
  }
}

# Log storage
resource "aws_s3_bucket" "log" {
  bucket = "mgl-airflow-log"
  
  tags = {
    "Name" = "Airflow log storage"
  }
}

# Airflow metastore
# resource "aws_db_instance" "metastore" {
#   identifier = "mgl-airflow-metastore"
#   instance_class = "db.t3.micro"
#   allocated_storage = 5
#   engine = "postgres"
#   engine_version = "14.1"
#   username = "mgl"
#   password = var.metastore_password
#   publicly_accessible = false
#   skip_final_snapshot = true
# }

# resource "aws_ecr_repository" "repo" {
#   name = "repo"
#   image_tag_mutability = "MUTABLE"
# }

# resource "aws_instance" "airflow" {
#   ami = 
#   instance_type = "t2.micro"

# }