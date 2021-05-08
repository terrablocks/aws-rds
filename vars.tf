variable "engine" {
  type        = string
  default     = "mysql"
  description = "Visit https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html for engine type"
}

variable "engine_version" {
  type        = string
  default     = "8.0.23"
  description = "Visit https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html for engine version"
}

variable "instance_name" {
  type        = string
  default     = "mysql-db"
  description = "Name of RDS instance"
}

variable "random_password" {
  type        = bool
  default     = true
  description = "Whether to generate random password. This password will be stored in SSM Parameter Store as a `SecureString`"
}

variable "db_username" {
  type        = string
  default     = "dbadmin"
  description = "Master username for RDS instance"
}

variable "db_password" {
  type        = string
  default     = ""
  description = "Master password for RDS instance. This password will be stored in SSM Parameter Store as a `SecureString`. **Note:** Required if random_password is set to false"
}

variable "instance_type" {
  type        = string
  default     = "db.t3.medium"
  description = "Instance type for RDS database"
}

variable "ca_cert" {
  type        = string
  default     = "rds-ca-2019"
  description = "Root CA cert to be used for in-transit encryption"
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "Type of storage to be used for RDS instance"
}

variable "storage_size" {
  type        = number
  default     = 50
  description = "Size of EBS storage attached to database"
}

variable "iops" {
  type        = number
  default     = 0
  description = "IOPS for EBS storage. **Note:** Required only for io1 volume"
}

variable "max_allocated_storage" {
  type        = number
  default     = 1000
  description = "Enable storage auto-scaling feature. To disable provide 0 as value"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "Whether to deploy a multi-az database"
}

variable "subnet_group_name" {
  type        = string
  default     = ""
  description = "Database subnet group to be used while launching database. **Note:** Either of subnet_group_name or subnet_ids is required"
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet IDs to be used for launching database. **Note:** Either of subnet_group_name or subnet_ids is required"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether to allow access from outside world"
}

variable "sg_ids" {
  type        = list(string)
  description = "List of security groups to be attached to RDS instance"
}

variable "db_port" {
  type        = number
  default     = 3306
  description = "Port on which database should accept incoming connections"
}

variable "db_name" {
  type        = string
  default     = ""
  description = "Name of the default database to be created"
}

variable "parameter_group_name" {
  type        = string
  default     = "default.mysql8.0"
  description = "Parameter group name to be used for database"
}

variable "option_group_name" {
  type        = string
  default     = "default:mysql-8-0"
  description = "Option group name to be used for database"
}

variable "storage_encrypted" {
  type        = bool
  default     = true
  description = "Whether to apply server-side encryption"
}

variable "db_kms_key" {
  type        = string
  default     = "alias/aws/rds"
  description = "KMS key to use for server-side encryption"
}

variable "ssm_kms_key" {
  type        = string
  default     = "alias/aws/ssm"
  description = "KMS key to store encrypted password in AWS SSM Parameter store service"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain automated backups"
}

variable "backup_window" {
  type        = string
  default     = ""
  description = "The time period when backup activity must be performed"
}

variable "copy_tags_to_snapshot" {
  type        = bool
  default     = true
  description = "Whether to copy RDS tags to snapshot"
}

variable "monitoring_interval" {
  type        = number
  default     = 0
  description = "To enable detailed monitoring provide interval in seconds. Valid Values: 0, 1, 5, 10, 15, 30, 60. 0 wil disable detailed monitoring"
}

variable "cw_log_exports" {
  type        = list(string)
  default     = []
  description = "List of logs to be exported to cloudwatch logs"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Whether to update minor version of database if available"
}

variable "maintenance_window" {
  type        = string
  default     = ""
  description = "The time period when maintenance activity must be performed"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Whether to skip final snapshot when terminating database"
}

variable "final_snapshot_identifier" {
  type        = string
  default     = "db-final-snapshot"
  description = "Name of final snapshot that will be created before deleting database"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Option to prevent accidental deletion of RDS instance"
}

variable "enable_iam_auth" {
  type        = bool
  default     = false
  description = "Whether to enable IAM authetication feature for database"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable performance insights"
}

variable "performance_insights_kms_key" {
  type        = string
  default     = "alias/aws/rds"
  description = "KMS key to be used for encrypting database insight data"
}

variable "performance_insights_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain performance insights data"
}

variable "db_license" {
  type        = string
  default     = "bring-your-own-license"
  description = "Type of license required to use the database. Valid values: license-included, bring-your-own-license. **Note:** Required only for Oracle database"
}

variable "character_set" {
  type        = string
  default     = "UTF8"
  description = "Character set to be used for database. **Note:** Required only for Oracle database"
}

variable "ad_domain_id" {
  type        = string
  default     = ""
  description = "Active Directory domain ID to connect to MS-SQL database. **Note:** Required only for MS-SQL Server"
}

variable "timezone" {
  type        = string
  default     = ""
  description = "Timezone to be set for database. **Note:** Required only for MS-SQL Server"
}

variable "snapshot_id" {
  type        = string
  default     = ""
  description = "If you want to restore a snapshot or create database from an existing snapshot please provide the snapshot ID"
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Apply database changes immediately instead of waiting until next maintenance windows"
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = false
  description = "Indicates that major version upgrades are allowed"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to associate with db instance"
}
