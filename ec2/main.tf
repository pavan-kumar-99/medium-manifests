resource "aws_instance" "web" {
  ami               = "ami-0851b76e8b1bce90b"
  instance_type     = "t3.micro"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "HelloAtlantis"
  }
}
