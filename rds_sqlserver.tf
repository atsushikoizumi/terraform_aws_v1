# aws_db_parameter_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
resource "aws_db_parameter_group" "rds_sqlserver_pg" {
  name   = "${var.tags_owner}-rds-sqlserver-pg"
  family = var.rds_sqlserver_pg_family

  tags = {
    Owner = var.tags_owner
  }
}

# aws_db_option_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group
resource "aws_db_option_group" "rds_sqlserver_opg" {
  name                 = "${var.tags_owner}-rds-sqlserver-opg"
  engine_name          = var.rds_sqlserver_eg_nm
  major_engine_version = var.rds_sqlserver_op_ev

  option {
    option_name = "SQLSERVER_BACKUP_RESTORE"

    option_settings {
      name  = "IAM_ROLE_ARN"
      value = aws_iam_role.rds_role.arn
    }

  }

  option {
    option_name = "SQLSERVER_AUDIT"

    option_settings {
      name  = "ENABLE_COMPRESSION"
      value = true
    }
    option_settings {
      name  = "S3_BUCKET_ARN"
      value = var.sqlserver_audit_s3_arn
    }
    option_settings {
      name  = "IAM_ROLE_ARN"
      value = aws_iam_role.rds_role.arn
    }
    option_settings {
      name  = "RETENTION_TIME"
      value = 0
    }

  }

  tags = {
    Owner = var.tags_owner
  }
}


# aws_db_instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance
resource "aws_db_instance" "rds_sqlserver_instance" {
  identifier     = "${var.tags_owner}-sqlserver"
  instance_class = var.rds_sqlserver_instance_class
  engine         = var.rds_sqlserver_eg_nm
  engine_version = var.rds_sqlserver_ev
  license_model  = var.rds_sqlserver_lisence
  multi_az       = false # default false
  username       = var.rds_sqlserver_user
  password       = var.rds_sqlserver_user_pass

  # storage
  storage_type          = "gp2" # The default is "io1", "gp2", "standard" (magnetic)
  allocated_storage     = 20    # depends on storage_type
  max_allocated_storage = 1000  # Must be greater than or equal to allocated_storage or 0 to disable Storage Autoscaling.
  storage_encrypted     = true  # declare KMS key ARN if true, default false
  # kms_key_id               = ""  # set KMS ARN if storage_encrypted is true, default "aws/rds"

  # network
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  port                   = 1433

  # monitoring
  performance_insights_enabled    = false                                # default false
  monitoring_interval             = 60                                   # 0, 1, 5, 10, 15, 30, 60 (seconds). default 0 (off)
  monitoring_role_arn             = aws_iam_role.rds_monitoring_role.arn # https://github.com/terraform-providers/terraform-provider-aws/issues/315
  enabled_cloudwatch_logs_exports = ["agent", "error"]

  # backup snapshot
  backup_retention_period   = 0                                      # default 7 (days). 0 = disabled.
  copy_tags_to_snapshot     = true                                   # default false
  delete_automated_backups  = true                                   # default true
  deletion_protection       = false                                  # default false
  skip_final_snapshot       = true                                   # default false
  final_snapshot_identifier = "${var.tags_owner}-sqlserver-snapshot" # must be provided if skip_final_snapshot is set to false.

  # window time
  backup_window      = "01:00-01:30" # must not overlap with maintenance_window.
  maintenance_window = "Mon:02:00-Mon:03:00"

  # options
  parameter_group_name       = aws_db_parameter_group.rds_sqlserver_pg.name
  option_group_name          = aws_db_option_group.rds_sqlserver_opg.name
  character_set_name         = var.rds_sqlserver_chara # Oracle and Microsoft SQL
  timezone                   = var.rds_sqlserver_timezone
  auto_minor_version_upgrade = false # default true

  # tags
  tags = {
    Owner = var.tags_owner
  }
}