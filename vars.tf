variable "engine" {
  default     = "mysql"
  description = "Visit https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html for engine type"
}

variable "engine_version" {
  default = "5.7"
}

variable "instance_name" {
  default = "mysql-db"
}

variable "random_password" {
  default = true
}

variable "db_username" {
  default = "dbadmin"
}

variable "db_password" {
  default = ""
}

variable "instance_type" {
  default = "db.t3.medium"
}

variable "ca_cert" {
  default = "rds-ca-2019"
}

variable "storage_type" {
  default = "gp2"
}

variable "storage_size" {
  default = 20
}

variable "iops" {
  default = 0
}

variable "max_allocated_storage" {
  default = 1000
}

variable "multi_az" {
  default = true
}

variable "subnet_group_name" {
  default = ""
}

variable "subnet_ids" {
  type    = list(any)
  default = []
}

variable "publicly_accessible" {
  default = false
}

variable "sg_ids" {
  type = list(any)
}

variable "db_port" {
  default = 3306
}

variable "db_name" {
  default = ""
}

variable "parameter_group_name" {
  default = "default.mysql5.7"
}

variable "option_group_name" {
  default = "default:mysql-5-7"
}

variable "storage_encrypted" {
  default = true
}

variable "db_kms_key" {
  default = "alias/aws/rds"
}

variable "ssm_kms_key" {
  default = "alias/aws/ssm"
}

variable "backup_retention_period" {
  default = 7
}

variable "backup_window" {
  default = ""
}

variable "copy_tags_to_snapshot" {
  default = true
}

variable "monitoring_interval" {
  default = 0
}

variable "cw_log_exports" {
  type    = list(any)
  default = []
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "maintenance_window" {
  default = ""
}

variable "skip_final_snapshot" {
  default = false
}

variable "final_snapshot_identifier" {
  default = "db-final-snapshot"
}

variable "deletion_protection" {
  default = true
}

variable "enable_iam_auth" {
  default = false
}

variable "performance_insights_enabled" {
  default = true
}

variable "performance_insights_kms_key" {
  default = "alias/aws/rds"
}

variable "performance_insights_retention_period" {
  default = 7
}

variable "db_license" {
  default = "bring-your-own-license"
}

variable "character_set" {
  default = "UTF8"
}

variable "ad_domain_id" {
  default = ""
}

variable "timezone" {
  default = ""
}

variable "snapshot_id" {
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}
