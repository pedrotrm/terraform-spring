resource "aws_network_interface" "nic-aula-db" {
  subnet_id       = aws_subnet.sub-aula.id
  private_ips     = ["10.80.4.10"]
  security_groups = [aws_security_group.sg-aula.id]
}

resource "aws_instance" "vm-aula-db" {
  instance_type = "t2.small"
  ami           = "ami-05eeafbc1fd393e9b"
  key_name      = aws_key_pair.key-aula.id

  network_interface {
    network_interface_id = aws_network_interface.nic-aula-db.id
    device_index         = 0
  }

  tags = {
    project = "aula"
  }
}

resource "null_resource" "upload-db" {
  triggers = {
    order = aws_instance.vm-aula-db.id
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = aws_instance.vm-aula-db.public_ip
    }

    source      = "mysql"
    destination = "/home/ubuntu"
  }
}

resource "null_resource" "deploy-db" {
  triggers = {
    order = null_resource.upload-db.id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = aws_instance.vm-aula-db.public_ip
    }

    inline = [
      "chmod 777 /home/ubuntu/mysql/install.sh",
      "cd /home/ubuntu/mysql/ && ./install.sh"
    ]
  }
}
