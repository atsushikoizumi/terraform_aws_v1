# rds_monitoring_role
resource "aws_iam_role" "rds_monitoring_role" {
  name = "${var.tags_owner}-rds-monitoring-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    Name  = "${var.tags_owner}-rds-monitoring-role"
    Owner = var.tags_owner
  }
}

resource "aws_iam_policy_attachment" "rds_monitoring_policy_attachment" {
  name       = "rds_monitoring_policy_attachment"
  roles      = [aws_iam_role.rds_monitoring_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
