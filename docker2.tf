#docker 2 instance as worker and join swarm
resource "aws_instance" "docker2" {
   depends_on = [aws_instance.docker1]
   ami = data.aws_ami.ubuntu.id
   instance_type = "t2.micro"
   key_name = "aws5"
   vpc_security_group_ids = [aws_security_group.docker.id]
   subnet_id = aws_subnet.docker.id
   tags = {
       Name = "docker2"
   }

  provisioner "file" {
  source = "/home/join_swarm.sh"
  destination = "/home/ubuntu/join_swarm.sh"

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file ("/root/aws/aws5.pem")
    host = aws_instance.docker2.public_ip
   }
 }

 provisioner "remote-exec" {
   inline = [
     "sleep 250",
     "echo public IP is: ${aws_instance.docker2.public_ip}",
     "sudo killall apt apt-get",
     "sudo apt-get update",
     "sudo rm /var/lib/apt/lists/lock",
     "sudo rm /var/cache/apt/archives/lock",
     "sudo rm /var/lib/dpkg/lock*",
     "sudo apt-get install -y vim",
     "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
     "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add",
     "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
     "sudo apt-get update",
     "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
     "sudo docker run hello-world",
     "echo ${aws_instance.docker1.private_ip} > /home/ubuntu/master_ip",
     "sleep 10",
     "chmod 755 /home/ubuntu/join_swarm.sh",
     "/home/ubuntu/join_swarm.sh"
     ]
 
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("/root/aws/aws5.pem")
    host = aws_instance.docker2.public_ip
   }
  }
}

output "docker2" {
  value = aws_instance.docker2.private_ip
}

output "app_state_docker2" {
  value = aws_instance.docker2.instance_state
}
