# aws_rds_cluster_parameter_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group
resource "aws_rds_cluster_parameter_group" "aurora_postgre_cpg" {
  name   = "${var.tags_owner}-aurora-postgre-cpg"
  family = var.aurora_postgre_cpg_family
  tags = {
    Owner = var.tags_owner
  }

  # install libraries
  parameter {
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements ,pg_hint_plan ,pgaudit"
    apply_method = "pending-reboot"
  }

  # audit setting
  parameter {
    name         = "pgaudit.log_catalog"
    value        = true
    apply_method = "immediate"
  }
  parameter {
    name         = "pgaudit.log_parameter"
    value        = true
    apply_method = "immediate"
  }
  parameter {
    name         = "pgaudit.log_relation"
    value        = true
    apply_method = "immediate"
  }
  parameter {
    name         = "pgaudit.log_statement_once"
    value        = true
    apply_method = "immediate"
  }
  parameter {
    name         = "pgaudit.log"
    value        = "ddl ,misc ,role"
    apply_method = "immediate"
  }
  parameter {
    name         = "pgaudit.role"
    value        = "rds_pgaudit"
    apply_method = "immediate"
  }

  # no local
  parameter {
    name         = "lc_messages"
    value        = "C"
    apply_method = "immediate"
  }
  parameter {
    name         = "lc_monetary"
    value        = "C"
    apply_method = "immediate"
  }
  parameter {
    name         = "lc_numeric"
    value        = "C"
    apply_method = "immediate"
  }
  parameter {
    name         = "lc_time"
    value        = "C"
    apply_method = "immediate"
  }
}

# aws_db_parameter_group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
resource "aws_db_parameter_group" "aurora_postgre_pg" {
  name   = "${var.tags_owner}-aurora-postgre-pg"
  family = var.aurora_postgre_pg_family
  tags = {
    Owner = var.tags_owner
  }
}

# aws_rds_cluster
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
resource "aws_rds_cluster" "aurora_postgre_cls" {
  cluster_identifier = "${var.tags_owner}-aurora-postgre-cls"
  engine             = "aurora-postgresql"
  engine_version     = var.aurora_postgre_cls_ev
  engine_mode        = "provisioned" # global,multimaster,parallelquery,serverless, default provisioned
  database_name      = var.aurora_postgre_dbname
  master_username    = var.aurora_postgre_master_user
  master_password    = var.aurora_postgre_master_user_pass

  # storage
  storage_encrypted = true # declare KMS key ARN if true, default false
  # kms_key_id               = ""  # set KMS ARN if storage_encrypted is true, default "aws/rds"

  # network
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  port                   = 5432

  # backup snapshot
  backup_retention_period   = 1                                  # must be between 1 and 35. default 1 (days)
  copy_tags_to_snapshot     = true                               # default false
  deletion_protection       = false                              # default false
  skip_final_snapshot       = true                               # default false
  final_snapshot_identifier = "${var.tags_owner}-aurora-postgre" # must be provided if skip_final_snapshot is set to false.

  # monitoring
  enabled_cloudwatch_logs_exports = ["postgresql"]

  # window time
  preferred_backup_window      = "02:00-02:30"
  preferred_maintenance_window = "Mon:03:00-Mon:04:00"

  # options
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_postgre_cpg.name

  # tags
  tags = {
    Owner = var.tags_owner
  }
}

# aws_rds_cluster_instance
resource "aws_rds_cluster_instance" "aurora_postgre_instance" {
  count              = 2
  identifier         = "${var.tags_owner}-aurora-postgre-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_postgre_cls.cluster_identifier
  instance_class     = var.aurora_postgre_instance_class
  engine             = "aurora-postgresql"
  engine_version     = var.aurora_postgre_cls_ev

  # netowrok
  #availability_zone = ""   # eu-west-1a,eu-west-1b,eu-west-1c

  # monitoring
  performance_insights_enabled = false                                # default false
  monitoring_interval          = 60                                   # 0, 1, 5, 10, 15, 30, 60 (seconds). default 0 (off)
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn # https://github.com/terraform-providers/terraform-provider-aws/issues/315

  # options
  db_parameter_group_name    = aws_db_parameter_group.aurora_postgre_pg.name
  auto_minor_version_upgrade = false

  # tags
  tags = {
    Owner = var.tags_owner
  }
}