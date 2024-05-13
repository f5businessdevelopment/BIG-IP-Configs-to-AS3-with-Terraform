resource "aws_instance" "example" {
  ami           = "ami-023e152801ee4846a" # Specify your desired AMI
  instance_type = "t2.micro" # Specify your desired instance type
  private_ip                  = "10.0.0.102"
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.f5.id]
 key_name                    = aws_key_pair.example.key_name
  user_data                   = templatefile("template/agent.tpl", local.agent_vars)
 tags = {
    Name = "student${var.prefix}-agent"
    Env  = "Env-${var.prefix}"
  }

}
locals {
agent_vars = {
agent_token = var.agentoken
agent_pool = "big-pool"

  }
}

output "agent_public_ip" {
  value = aws_instance.example.public_ip
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = file("work.pub") # Change the path to your public key
}

