data "aws_vpc" "my_vpc" {
  id = var.vpc_id
}

data "aws_ami" "amzn-linux" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}