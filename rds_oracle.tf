# aws_db_parameter_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
resource "aws_db_parameter_group" "rds_oracle_pg" {
  name   = "${var.tags_owner}-rds-oracle-pg"
  family = var.rds_oracle_pg_family

  parameter {
    name         = "audit_trail"
    value        = "DB,EXTENDED"
    apply_method = "pending-reboot"
  }

  tags = {
    Owner = var.tags_owner
  }
}

# aws_db_option_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group
resource "aws_db_option_group" "rds_oracle_opg" {
  name                 = "${var.tags_owner}-rds-oracle-opg"
  engine_name          = var.rds_oracle_eg_nm
  major_engine_version = var.rds_oracle_op_ev

  option {
    option_name = "S3_INTEGRATION"
  }

  option {
    option_name = "Timezone"

    option_settings {
      name  = "TIME_ZONE"
      value = var.rds_oracle_timezone
    }
  }

  tags = {
    Owner = var.tags_owner
  }
}


# aws_db_instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_instance
resource "aws_db_instance" "rds_oracle_instance" {
  identifier     = "${var.tags_owner}-oracle"
  instance_class = var.rds_oracle_instance_class
  engine         = var.rds_oracle_eg_nm
  engine_version = var.rds_oracle_ev
  license_model  = var.rds_oracle_lisence
  multi_az       = false                 # default false
  name           = var.rds_oracle_dbname # must be upper, default ORCL
  username       = var.rds_oracle_user
  password       = var.rds_oracle_user_pass

  # storage
  storage_type          = "gp2" # The default is "io1", "gp2", "standard" (magnetic)
  allocated_storage     = 20    # depends on storage_type
  max_allocated_storage = 1000  # Must be greater than or equal to allocated_storage or 0 to disable Storage Autoscaling.
  storage_encrypted     = true  # declare KMS key ARN if true, default false
  # kms_key_id               = ""  # set KMS ARN if storage_encrypted is true, default "aws/rds"

  # network
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  port                   = 1521

  # monitoring
  performance_insights_enabled    = false                                # default false
  monitoring_interval             = 60                                   # 0, 1, 5, 10, 15, 30, 60 (seconds). default 0 (off)
  monitoring_role_arn             = aws_iam_role.rds_monitoring_role.arn # https://github.com/terraform-providers/terraform-provider-aws/issues/315
  enabled_cloudwatch_logs_exports = ["alert", "audit", "listener", "trace"]

  # backup snapshot
  backup_retention_period   = 0                                   # default 7 (days). 0 = disabled.
  backup_window             = "01:00-01:30"                       # must not overlap with maintenance_window.
  copy_tags_to_snapshot     = true                                # default false
  delete_automated_backups  = true                                # default true
  deletion_protection       = false                               # default false
  skip_final_snapshot       = true                                # default false
  final_snapshot_identifier = "${var.tags_owner}-oracle-snapshot" # must be provided if skip_final_snapshot is set to false.

  # options
  parameter_group_name       = aws_db_parameter_group.rds_oracle_pg.name
  option_group_name          = aws_db_option_group.rds_oracle_opg.name
  character_set_name         = var.rds_oracle_chara # Oracle and Microsoft SQL
  auto_minor_version_upgrade = false                # default true
  maintenance_window         = "Mon:02:00-Mon:03:00"

  # tags
  tags = {
    Owner = var.tags_owner
  }
}