# aws_rds_cluster_parameter_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group
resource "aws_rds_cluster_parameter_group" "aurora_mysql_cpg" {
  name   = "${var.tags_owner}-aurora-mysql-cpg"
  family = var.aurora_mysql_cpg_family
  tags = {
    Owner = var.tags_owner
  }
  parameter {
    name         = "character_set_client"
    value        = var.aurora_mysql_cpg_character
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = var.aurora_mysql_cpg_character
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = var.aurora_mysql_cpg_character
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = var.aurora_mysql_cpg_character
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = var.aurora_mysql_cpg_character
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = var.aurora_mysql_cpg_character
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = var.aurora_mysql_cpg_collation
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = var.aurora_mysql_cpg_collation
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = var.aurora_mysql_cpg_timezone
    apply_method = "immediate"
  }

  parameter {
    name         = "server_audit_events"
    value        = "CONNECT,QUERY_DCL,QUERY_DDL"
    apply_method = "immediate"
  }

  parameter {
    name         = "server_audit_logging"
    value        = true
    apply_method = "immediate"
  }
  parameter {
    name         = "server_audit_logs_upload"
    value        = true
    apply_method = "immediate"
  }
  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "immediate"
  }
  parameter {
    name         = "slow_query_log"
    value        = true
    apply_method = "immediate"
  }

}

# aws_db_parameter_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
resource "aws_db_parameter_group" "aurora_mysql_pg" {
  name   = "${var.tags_owner}-aurora-mysql-pg"
  family = var.aurora_mysql_pg_family
  tags = {
    Owner = var.tags_owner
  }
}

# aws_db_option_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group
resource "aws_db_option_group" "aurora_mysql_opg" {
  name                 = "${var.tags_owner}-aurora-mysql-opg"
  engine_name          = "mysql"
  major_engine_version = var.aurora_mysql_opg_ev
  tags = {
    Owner = var.tags_owner
  }
}

# aws_rds_cluster
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
resource "aws_rds_cluster" "aurora_mysql_cls" {
  cluster_identifier = "${var.tags_owner}-aurora-mysql-cls"
  engine             = "aurora-mysql"
  engine_version     = var.aurora_mysql_cls_ev
  engine_mode        = "provisioned" # global,multimaster,parallelquery,serverless, default provisioned
  master_username    = var.aurora_mysql_master_user
  master_password    = var.aurora_mysql_master_user_pass
  database_name      = var.aurora_mysql_dbname

  # storage
  storage_encrypted = false # declare KMS key ARN if true, default false
  # kms_key_id               = ""  # set KMS ARN if storage_encrypted is true, default "aws/rds"

  # network
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  port                   = 3306

  # backup snapshot
  backtrack_window          = 72                                        # default 0
  backup_retention_period   = 1                                         # must be between 1 and 35. default 1 (days)
  copy_tags_to_snapshot     = true                                      # default false
  deletion_protection       = false                                     # default false
  skip_final_snapshot       = true                                      # default false
  final_snapshot_identifier = "${var.tags_owner}-aurora-mysql-snapshot" # must be provided if skip_final_snapshot is set to false.

  # monitoring
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  # options
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql_cpg.name

  # window time
  preferred_backup_window      = "02:00-02:30"
  preferred_maintenance_window = "Mon:03:00-Mon:04:00"

  # tags
  tags = {
    Owner = var.tags_owner
  }
}

# aws_rds_cluster_instance
resource "aws_rds_cluster_instance" "aurora_mysql_instance" {
  count              = 2
  identifier         = "${var.tags_owner}-aurora-mysql-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_mysql_cls.cluster_identifier
  instance_class     = var.aurora_mysql_instance_class
  engine             = "aurora-mysql"
  engine_version     = var.aurora_mysql_cls_ev

  # netowrok
  #availability_zone = ""   # eu-west-1a,eu-west-1b,eu-west-1c

  # monitoring
  performance_insights_enabled = false                                # default false
  monitoring_interval          = 60                                   # 0, 1, 5, 10, 15, 30, 60 (seconds). default 0 (off)
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn # https://github.com/terraform-providers/terraform-provider-aws/issues/315

  # options
  db_parameter_group_name    = aws_db_parameter_group.aurora_mysql_pg.name
  auto_minor_version_upgrade = false

  # tags
  tags = {
    Owner = var.tags_owner
  }
}