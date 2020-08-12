# Subnet
# https://www.terraform.io/docs/providers/aws/r/subnet.html
# https://www.terraform.io/docs/configuration/functions/cidrsubnet.html
resource "aws_subnet" "subnet_ec2" {
  count                   = 1
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  map_public_ip_on_launch = true # Required to set Public IP when creating EC2
  tags = {
    Name  = "${var.tags_owner}-subnet-ec2"
    Owner = var.tags_owner
  }
}

resource "aws_subnet" "subnet_rds" {
  count                   = 3
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 101)
  map_public_ip_on_launch = false
  availability_zone       = var.rds_az[count.index]

  tags = {
    Name  = "${var.tags_owner}-subnet-rds"
    Owner = var.tags_owner
  }
}

# Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Owner = var.tags_owner
  }
}

# Route
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "route_ec2" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.route_table.id
  gateway_id             = aws_internet_gateway.igw.id
}

# Route Table Asoociation
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet_ec2.0.id
  route_table_id = aws_route_table.route_table.id
}