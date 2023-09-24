resource "aws_instance" "web" {
  ami                    = data.aws_ami.amzn-linux.id
  instance_type          = var.instance_type
  user_data              = file("userdata.sh")
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = "linux"

  provisioner "file" {
    source      = "./index.html"
    destination = "index.html"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    private_key = file("linux.pem")
    user        = "ec2-user"
    timeout     = "4m"
  }

  tags = {
    Name = "NewServer"
  }
}

resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.my_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg"
  }
}