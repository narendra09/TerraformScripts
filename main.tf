provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAS4V27AFLJ5SG4NDJ"
  secret_key = "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"
  
}
resource "aws_instance" "web" {
    ami ="ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    key_name ="ACM"
    vpc_security_group_ids  =["${aws_security_group.sg.id}"]
    associate_public_ip_address ="true"
    subnet_id ="${aws_subnet.web.id}"
    connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${file("./ACM.pem")}"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install software-properties-common -y",
            "sudo apt-add-repository --yes --update ppa:ansible/ansible",
            "sudo apt-get install ansible -y",
            "sudo git clone https://github.com/narendra09/terraform.git",
            "ansible-playbook -i /home/ubuntu/terraform/inventory /home/ubuntu/terraform/git.yml"
            ]
    }
   
    tags {
        Name = "web"
    } 
}
