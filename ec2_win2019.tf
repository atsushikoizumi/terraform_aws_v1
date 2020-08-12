# search ami
# https://dev.classmethod.jp/articles/launch-ec2-from-latest-ami-by-terraform/
data "aws_ami" "win2019_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["Windows_Server-2019-Japanese-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

# EC2
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "win2019_1" {
  ami           = data.aws_ami.win2019_ami.id
  instance_type = var.win2019_1_instance_type
  key_name      = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [
    aws_security_group.public_sg.id
  ]
  subnet_id = aws_subnet.subnet_ec2.0.id
  root_block_device {
    volume_type = var.win2019_1_volume_type
    volume_size = var.win2019_1_volume_size
  }
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name  = "${var.tags_owner}-win2019"
    Owner = var.tags_owner
  }
}