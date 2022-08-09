# # Creation of VM in AWS 
#  - Security group 

resource "aws_security_group" "allow_SSH" {
  name        = "allow_SSH1"
  description = "Allow SSH inbound traffic"

  #  - INBOUND

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #  - OUTBOUND RULES

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#  - key pair

resource "aws_key_pair" "deployer1" {
  key_name   = "deployer-key11"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDmehnhRzJStO0i+8p2jfhVrUtz3rIxcXLO6rLGzwgxF/OXgB79cWbxoaS040Z6zhWDppzwYXGzIRZxkLlWg5apJdBiX29LKURxXCzZPU1R6ICKHDoqFgS3fIandO8YUBjT2vq8pOmwkRf052C9gadqR1bXExi98ilKsyQoMWzKH/AtN9VJJlRgbnWI41PzB3B/xzhQL9QlBBie5H7/zXFrfk614lKLeptlSmYc8ai/1uRWovz0I/CI/GjA6+EktWfHwdJ0r0VmUGagguZILZunatOKmLRVigDXnBGtX7qQzbO+ipkRCeU+7Ho0GRUIqBIGV1vLeX3y2Q3bMn8rUoGO9PBqMKZA9k4I2kjBydwMFIqJyk23iSY+HGJ6SZXgwE++ZCz8vrDF6heh8c85vd2l3sn5towRQom38mk5jM7zqwbqTZrTqbhR965CEKXnXg482B2hJM+qXrdx7z21A8Ymw2EbY93pzhgjDqR9gzt8KYCvR1v/i+iHLZRbZX3ODAk= dishakhanai27gm@ip-172-31-17-52"
}

resource "aws_instance" "ubuntu" {
  ami                    = "ami-04505e74c0741db8d"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer1.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_SSH.id}"]
  tags = {
    "Name" = "UBUNTU-Node"
    "ENV"  = "Dev"
  }
  # Type of connection to be established
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./deployer")
    host        = self.public_ip
  }

  # Remotely execute commands to install Java, Python, Jenkins
  provisioner "remote-exec" {
    inline = [
      "sudo apt update && upgrade",
      "sudo apt install -y python3.8",
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ >  /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get update",
      "sudo apt-get install -y openjdk-8-jre",
      "sudo apt-get install -y jenkins",
      "sudo apt-get install -y docker docker.io",
      "sudo chmod 777 /var/run/docker.sock",
      "sudo cat  /var/lib/jenkins/secrets/initialAdminPassword",
    ]
  }
  depends_on = [aws_key_pair.deployer1]

}