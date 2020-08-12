# DB Subnet
# https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html
resource "aws_db_subnet_group" "db_subnet" {
  name = "${var.tags_owner}-db-subnet-gp"
  subnet_ids = [
    aws_subnet.subnet_rds.0.id,
    aws_subnet.subnet_rds.1.id,
    aws_subnet.subnet_rds.2.id
  ]
  tags = {
    Owner = var.tags_owner
  }
}