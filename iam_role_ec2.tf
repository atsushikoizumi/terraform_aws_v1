# aws_iam_instance_profile
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

# aws_iam_role
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "ec2_role" {
  name = "${var.tags_owner}-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    Name  = "${var.tags_owner}-ec2-role"
    Owner = var.tags_owner
  }
}

# aws_iam_policy_attachment
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
resource "aws_iam_policy_attachment" "ec2_policy_1_attachment" {
  name       = "ec2_policy_1_attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy_1.arn
}

resource "aws_iam_policy_attachment" "ec2_policy_2_attachment" {
  name       = "ec2_policy_2_attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy_2.arn
}

resource "aws_iam_policy_attachment" "ec2_policy_3_attachment" {
  name       = "ec2_policy_3_attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy_3.arn
}

resource "aws_iam_policy_attachment" "ec2_policy_4_attachment" {
  name       = "ec2_policy_4_attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy_4.arn
}

# aws_iam_policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "ec2_policy_1" {
  name        = "ec2_policy_1"
  path        = "/"
  description = "ec2_policy_1"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "S3:GetBucketAcl"
            ],
            "Resource": [
                "arn:aws:s3:::koizumi-backup/*",
                "arn:aws:s3:::koizumi-logs/*",
                "arn:aws:s3:::koizumi-data/*",
                "arn:aws:s3:::koizumi-backup",
                "arn:aws:s3:::koizumi-logs",
                "arn:aws:s3:::koizumi-data"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ec2_policy_2" {
  name        = "ec2_policy_2"
  path        = "/"
  description = "ec2_policy_2"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBClusterParameters",
                "rds:StartDBCluster",
                "rds:StopDBCluster",
                "rds:DescribeDBParameterGroups",
                "rds:StopDBInstance",
                "rds:StartDBInstance",
                "rds:ModifyDBParameterGroup",
                "rds:CreateDBCluster",
                "rds:CreateDBInstance",
                "rds:DescribeDBInstances",
                "rds:DescribeOptionGroups",
                "rds:ModifyDBClusterParameterGroup",
                "rds:DescribeDBParameters",
                "rds:DescribeDBClusters",
                "rds:DescribeDBClusterParameterGroups",
                "rds:CreateDBInstanceReadReplica",
                "rds:RebootDBInstance",
                "rds:CreateDBSubnetGroup",
                "rds:CreateDBClusterParameterGroup",
                "rds:CreateDBParameterGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ec2_policy_3" {
  name        = "ec2_policy_3"
  path        = "/"
  description = "ec2_policy_3"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ec2_policy_4" {
  name        = "ec2_policy_4"
  path        = "/"
  description = "ec2_policy_4"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
