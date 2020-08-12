# provider.tf
variable aws_region {}
variable tags_owner {}
variable vpc_cidr {}
variable rds_az {}
variable allow_ip {}

# key pair
variable public_key_path {}

# ec2 amazon linux 2
variable amzn2_ami_name {}
variable amzn2_1_instance_type {}
variable amzn2_1_volume_type {}
variable amzn2_1_volume_size {}
variable amzn2_1_user {}
variable ec2_root_pass {}

# ec2 windows server 2019
variable win2019_1_instance_type {}
variable win2019_1_volume_type {}
variable win2019_1_volume_size {}


# rds aurora mysql
variable aurora_mysql_cls_ev {}
variable aurora_mysql_cpg_family {}
variable aurora_mysql_pg_family {}
variable aurora_mysql_opg_ev {}
variable aurora_mysql_instance_class {}
variable aurora_mysql_cpg_character {}
variable aurora_mysql_cpg_collation {}
variable aurora_mysql_cpg_timezone {}
variable aurora_mysql_dbname {}
variable aurora_mysql_master_user {}
variable aurora_mysql_master_user_pass {}

# rds aurora postgresql
variable aurora_postgre_cpg_family {}
variable aurora_postgre_pg_family {}
variable aurora_postgre_cls_ev {}
variable aurora_postgre_dbname {}
variable aurora_postgre_master_user {}
variable aurora_postgre_master_user_pass {}
variable aurora_postgre_instance_class {}
variable aurora_postgre_local {}

# rds oracle
variable rds_oracle_pg_family {}
variable rds_oracle_eg_nm {}
variable rds_oracle_op_ev {}
variable rds_oracle_instance_class {}
variable rds_oracle_ev {}
variable rds_oracle_lisence {}
variable rds_oracle_dbname {}
variable rds_oracle_user {}
variable rds_oracle_user_pass {}
variable rds_oracle_timezone {}
variable rds_oracle_chara {}

# rds sqlserver
variable rds_sqlserver_pg_family {}
variable rds_sqlserver_eg_nm {}
variable rds_sqlserver_op_ev {}
variable rds_sqlserver_lisence {}
variable rds_sqlserver_timezone {}
variable rds_sqlserver_instance_class {}
variable rds_sqlserver_ev {}
variable rds_sqlserver_user {}
variable rds_sqlserver_user_pass {}
variable sqlserver_audit_s3_arn {}
variable rds_sqlserver_chara {}