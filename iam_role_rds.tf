# rds_role
resource "aws_iam_role" "rds_role" {
  name = "${var.tags_owner}-rds-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    Name  = "${var.tags_owner}-rds-role"
    Owner = var.tags_owner
  }
}

resource "aws_iam_policy_attachment" "rds_policy_1_attachment" {
  name       = "rds_policy_1_attachment"
  roles      = [aws_iam_role.rds_role.name]
  policy_arn = aws_iam_policy.rds_policy_1.arn
}

# aws_iam_policy
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "rds_policy_1" {
  name        = "rds_policy_1"
  path        = "/"
  description = "rds_policy_1"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "S3:GetBucketAcl",
                "s3:GetBucketLocation",
                "s3:GetObjectMetaData",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}