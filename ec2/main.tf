## AWS Auth
provider "aws" {
  version = "~>3.0"
  region  = "ap-south-1"
}

## Remote S3 Data Block
terraform {
  backend "s3" {
    bucket = "atlantisterraform"
    key    = "terraform/atlantisterraform/state"
    region = "ap-south-1"
  }
}

## Create an EC2 Instance
resource "aws_instance" "web" {
  ami               = "ami-0851b76e8b1bce90b"
  instance_type     = "t2.medium"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "atlantis-medium"
  }
}
