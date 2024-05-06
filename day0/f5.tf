
resource "aws_instance" "f5" {
  #F5 BIGIP-14.1.0.3-0.0.6 PAYG-Good 25Mbps-190326002717
  ami = "ami-0a4febf7d5f541674"
  instance_type               = "m5.xlarge"
  private_ip                  = "10.0.0.200"
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.f5.id]
  user_data                   = templatefile("template/f5.tpl", local.template_vars)
  key_name                    = aws_key_pair.demo.key_name
  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name = "student${var.prefix}-f5"
    Env  = "Env-${var.prefix}"
  }
}

resource "random_string" "password" {
  length  = 10
  special = false
}
locals {
  template_vars = {
    password = random_string.password.result
  }
}
output "F5_ui" {
  value = "https://${aws_eip.f5.public_ip}:8443"
}


output "F5_Password" {
  value = random_string.password.result
}
