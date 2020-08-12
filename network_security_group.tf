# Security Group
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "public_sg" {
  name        = "${var.tags_owner}-public-sg"
  description = "koizumi work Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ip
  }

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.allow_ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.tags_owner}-public-sg"
    Owner = var.tags_owner
  }
}

resource "aws_security_group" "private_sg" {
  name        = "${var.tags_owner}-private-sg"
  description = "koizumi work Security Group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [
      aws_security_group.public_sg.id
    ]
  }
  ingress {
    description = "PostgreSQL"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [
      aws_security_group.public_sg.id
    ]
  }
  ingress {
    description = "Oracle"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    security_groups = [
      aws_security_group.public_sg.id
    ]
  }
  ingress {
    description = "SQLServer"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    security_groups = [
      aws_security_group.public_sg.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name  = "${var.tags_owner}-private-sg"
    Owner = var.tags_owner
  }
}