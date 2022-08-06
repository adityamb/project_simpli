# project_simpli
Project - Terraform

# Automating Infrastructure using Terraform

# Configuring AWS
- Step 1 : Check if Terraform is Installed
- Step 2 : Open AWS
- Step 3 : In terminal run aws configure
- Step 4 : Update access Key and Secret key from AWS
- Step 5 : Run 'aws s3 ls' to check if connected with aws


# Writing terraform script for ec2
- Step 1 : create main.tf file
- Step 2 : Write scripts to deploy ec2 instance to aws using key pair
- Step 3 : run the below commands in terminal
```
    terraform init
    terraform plan
    terraform apply
```
- Step 4: confirm the ec2 instance is deployed in aws

# Connecting to ec2
- Step 1: In Terminal run the below commands
```
 ssh -i deployer ubuntu@x.x.x.x

```
- Step 2:Replace 'x.x.x.x' with ip address of instance

# Installing Jenkins, Java and Python
- Step 1: update the main.tf
```
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

```
- Step 2: Run commands in terminal
```
  terraform fmt
  terraform destroy and yes
  terraform init 
  terraform plan
  terraform apply

```
- Step 3: Wait for the installation to get over
- Step 4: confirm by going to browser and opening Jenkins using [ip_address]:8080
