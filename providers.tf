terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}
# Statefile remote backup using s3 bucket and locking with dynamodb
terraform {
  backend "s3" {
    bucket         = "insurancestatefile"
    key            = "terraform/state.tfstate"
    region         =  "ap-south-1"
    dynamodb_table = "insurancestatefile"
  }
}


resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = var.public_key
}