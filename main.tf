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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ4MIVLXRkT1qmshH/AgGILm1j1eQXdkeOmry9Rvj+2b7pUE9qzuB3sX74evR+SJFm1L6FzMIyNPVnlCuxtyQ8KaRIT7A9i64TomuKUzQy2ZnnM/bTAJrFAL/2yByMHPJbeUiZBw+fgiMeT0gW/WrAWvzwqzlbJOKIIIFBBkOqssc+Es/VnbneCZ32/Bwj1v/NwOGHlV54iGvHonNElIP31Sag1lidlghfCoPBu1+/mYPo1jCjcm+Swj2W/ottlp/g/IM3Gzf5zE/BL8bwuoxThk/ZUzOFZPo2mLSbaRjE7gaYNuni3Ruz+l+GKkBdh9BGfcY0DtmqmMld2SZazCr+vJKRof+SxxrNt24QkuK1RqMhThMA0LxiLgz7iuDClKPUZ9i+2Mf/lH3vUieZSSJg/qxZBwjleOir4J2MsExRyFJPVW7tHBZ+ZCE2gd3gqwp8lfWjLJ+PrjH9iYWiVVD38steIPzDd3QVi8pFK0Ck53JwmCvO+m8LapgCcBsDC9M= adityabhatambgm@ip-172-31-24-174"
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