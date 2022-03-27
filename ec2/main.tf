resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "HelloAtlantis"
  }
}
