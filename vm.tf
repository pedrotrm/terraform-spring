resource "aws_network_interface" "nic-aula" {
  subnet_id       = aws_subnet.sub-aula.id
  private_ips     = ["10.80.4.11"]
  security_groups = [aws_security_group.sg-aula.id]
}

resource "aws_instance" "vm-aula" {
  instance_type = "t2.small"
  ami           = "ami-05eeafbc1fd393e9b"
  key_name      = aws_key_pair.key-aula.id

  network_interface {
    network_interface_id = aws_network_interface.nic-aula.id
    device_index         = 0
  }

  tags = {
    project = "aula"
  }
}

resource "null_resource" "upload-app" {
  triggers = {
    order = aws_instance.vm-aula.id
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = aws_instance.vm-aula.public_ip
    }

    source      = "springapp"
    destination = "/home/ubuntu"
  }
}

resource "null_resource" "deploy-app" {
  triggers = {
    order = null_resource.upload-app.id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("id_rsa")
      host        = aws_instance.vm-aula.public_ip
    }

    inline = [
      "chmod 777 /home/ubuntu/springapp/install.sh",
      "cd /home/ubuntu/springapp/ && ./install.sh"
    ]
  }
}
