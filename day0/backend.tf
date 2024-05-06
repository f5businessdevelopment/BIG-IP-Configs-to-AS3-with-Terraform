resource "aws_instance" "app1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  private_ip                  = "10.0.0.171"
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[0]
  # vpc_security_group_ids = [aws_security_group.f5.id]
  user_data       = file("template/nginx.sh")
  security_groups = [aws_security_group.nginx.id]
  #iam_instance_profile   = aws_iam_instance_profile.vault.name
  key_name = aws_key_pair.demo.key_name
  tags = {
    Name = "student${var.prefix}-app1"
    Env  = "Env${var.prefix}"
  }
}
