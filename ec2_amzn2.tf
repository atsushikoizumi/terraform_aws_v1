# aws_ssm_parameter
# https://www.terraform.io/docs/providers/aws/d/ssm_parameter.html
data "aws_ssm_parameter" "amzn2_ami" {
  name = var.amzn2_ami_name
}

# EC2
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "amzn2_1" {
  ami           = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = var.amzn2_1_instance_type
  key_name      = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [
    aws_security_group.public_sg.id
  ]
  subnet_id = aws_subnet.subnet_ec2.0.id
  root_block_device {
    volume_type = var.amzn2_1_volume_type
    volume_size = var.amzn2_1_volume_size
  }
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data                   = <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo adduser ${var.amzn2_1_user}
  sudo cp -r /home/ec2-user/.ssh /home/${var.amzn2_1_user}/
  sudo chown -R ${var.amzn2_1_user}.${var.amzn2_1_user} /home/${var.amzn2_1_user}/.ssh
  echo ${var.amzn2_1_user} | sudo passwd --stdin ${var.amzn2_1_user}
  echo ${var.ec2_root_pass} | sudo passwd --stdin root
  sudo yum install -y curl
  sudo yum install -y unzip
  sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  sudo unzip awscliv2.zip
  sudo /home/ec2-user/aws/install
  sudo yum install -y yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
  sudo yum install -y yum-utils
  sudo yum-config-manager --disable mysql80-community
  sudo yum-config-manager --enable mysql57-community
  sudo yum install -y mysql-community-client
  sudo rpm -ivh --nodeps https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
  sudo sed -i "s/\$releasever/7/g" "/etc/yum.repos.d/pgdg-redhat-all.repo"
  sudo yum install -y postgresql11
  exit
  EOF
  tags = {
    Name  = "${var.tags_owner}-amzn2"
    Owner = var.tags_owner
  }
}