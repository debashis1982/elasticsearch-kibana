provider "aws" {}
resource "aws_instance" "lab" {
    ami = "ami-1e299d7e"
    instance_type = "t2.micro"
    tags {
        Name = "elasticsearch"
    }
   key_name = "debashis1982-new"
    provisioner "file" {
      source = "etc/yum.repos.d/elasticsearch.repo"
      destination = "/tmp/elasticsearch.repo"
      connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("~/.ssh/debashis1982-new.pem")}"
      }
    }
    provisioner "remote-exec" {
        inline = [
          "sudo yum -y install java-1.8.0",
          "sudo yum -y remove java-1.7.0-openjdk",
          "sudo mv /tmp/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo",
	  "sudo yum -y install elasticsearch",
	  "sudo sed -i 's/\\-Xm/#\\ \\-Xm/g' /etc/elasticsearch/jvm.options",
	  "sudo sh -c 'echo -Xms500m >>  /etc/elasticsearch/jvm.options'",
	  "sudo sh -c 'echo -Xmx500m >>  /etc/elasticsearch/jvm.options'",
	  "sudo sh -c 'echo network.host: 0.0.0.0 >> /etc/elasticsearch/elasticsearch.yml'",
	  "sudo service elasticsearch start"
        ]
         connection {
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("~/.ssh/debashis1982-new.pem")}"
         }
    }
}
