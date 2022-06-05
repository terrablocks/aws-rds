variable "engine" {
  type        = string
  default     = "mysql"
  description = "Visit https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html for engine type"
}

variable "engine_version" {
  type        = string
  default     = "8.0.27"
  description = "Visit https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html for engine version"
}

variable "instance_name" {
  type        = string
  default     = "mysql-db"
  description = "Name of the RDS instance"
}

variable "random_password" {
  type        = bool
  default     = true
  description = "Whether to generate a random password for the database. This password will be stored in SSM Parameter Store as a `SecureString` or in Secrets Manager depending on your choice"
}

variable "db_username" {
  type        = string
  default     = "dbadmin"
  description = "Master username for the RDS instance"
}

variable "db_password" {
  type        = string
  default     = ""
  description = "Master password for the RDS instance. This password will be stored in SSM Parameter Store as a `SecureString` or in Secrets Manager depending on your choice. **Note:** Required if random_password is set to false"
}

variable "instance_type" {
  type        = string
  default     = "db.t3.medium"
  description = "Instance type for the RDS database"
}

variable "ca_cert" {
  type        = string
  default     = "rds-ca-2019"
  description = "Root CA cert to use for in-transit encryption between the server and the RDS instance"
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "Type of storage to use for the RDS instance"
}

variable "storage_size" {
  type        = number
  default     = 50
  description = "Size of the EBS storage attached to database"
}

variable "iops" {
  type        = number
  default     = 0
  description = "IOPS for the EBS storage. **Note:** Required only for io1 volume"
}

variable "max_allocated_storage" {
  type        = number
  default     = 1000
  description = "Enable storage auto-scaling feature for the RDS instance. To disable set this to 0"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "Whether to deploy a multi-az database"
}

variable "db_subnet_group_name" {
  type        = string
  default     = ""
  description = "Database subnet group to use while launching the database. **Note:** Either of `db_subnet_group_name` or `db_subnet_ids` is required"
}

variable "db_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet IDs to use for creating a subnet group. **Note:** Either of `db_subnet_group_name` or `db_subnet_ids` is required"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether to allow database access over the public internet"
}

variable "db_sg_ids" {
  type        = list(string)
  default     = []
  description = "List of security groups ID to attach to the RDS instance. **Note:** Leave it blank to auto-create one and attach it to the RDS instance"
}

variable "db_port" {
  type        = number
  default     = 3306
  description = "Port on which database should accept incoming connections"
}

variable "db_name" {
  type        = string
  default     = ""
  description = "Name of the default database to create"
}

variable "parameter_group_name" {
  type        = string
  default     = "default.mysql8.0"
  description = "Parameter group name to use for database"
}

variable "option_group_name" {
  type        = string
  default     = "default:mysql-8-0"
  description = "Option group name to use for database"
}

variable "storage_encrypted" {
  type        = bool
  default     = true
  description = "Whether to enable server-side encryption for the RDS instance"
}

variable "db_kms_key" {
  type        = string
  default     = "alias/aws/rds"
  description = "KMS key to use for server-side encryption"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain automated backups"
}

variable "backup_window" {
  type        = string
  default     = null
  description = "The time period when backup activity will be performed"
}

variable "copy_tags_to_snapshot" {
  type        = bool
  default     = true
  description = "Whether to copy the RDS tags to the snapshot"
}

variable "monitoring_interval" {
  type        = number
  default     = 0
  description = "To enable detailed monitoring provide interval in seconds. Valid Values: 0, 1, 5, 10, 15, 30, 60. 0 will disable detailed monitoring"
}

variable "cw_log_exports" {
  type        = list(string)
  default     = []
  description = "List of logs to be exported to the cloudwatch logs"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Whether to update minor version of database if available"
}

variable "maintenance_window" {
  type        = string
  default     = null
  description = "The time period when maintenance activity will be performed"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Whether to skip final snapshot before terminating the RDS instance"
}

variable "final_snapshot_identifier" {
  type        = string
  default     = "db-final-snapshot"
  description = "Name of final snapshot to create before deleting the RDS instance"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Whether to prevent accidental deletion of RDS instance"
}

variable "enable_iam_auth" {
  type        = bool
  default     = false
  description = "Whether to enable IAM authetication feature for the RDS instance"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable performance insights for the RDS instance"
}

variable "performance_insights_kms_key" {
  type        = string
  default     = "alias/aws/rds"
  description = "KMS key to use for encrypting database insight data"
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
  description = "Character set to use for the database. **Note:** Required only for Oracle database"
}

variable "ad_domain_id" {
  type        = string
  default     = null
  description = "Active Directory domain ID to connect to the MS-SQL database. **Note:** Required only for the MS-SQL Server"
}

variable "timezone" {
  type        = string
  default     = null
  description = "Timezone to set for the database. **Note:** Required only for the MS-SQL Server"
}

variable "snapshot_id" {
  type        = string
  default     = null
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

variable "use_ssm" {
  type        = bool
  default     = false
  description = "Use SSM Parameter Store to securely store the database password"
}

variable "ssm_kms_key" {
  type        = string
  default     = "alias/aws/ssm"
  description = "KMS key to use for encrypting the password in AWS SSM Parameter Store service"
}

variable "use_secretsmanager" {
  type        = bool
  default     = true
  description = "Use Secrets Manager to securely store the database password"
}

variable "secretsmanager_kms_key" {
  type        = string
  default     = "alias/aws/secretsmanager"
  description = "KMS key to use for encrypting the password in AWS Secrets Manager service"
}

variable "secretsmanager_policy" {
  type        = string
  default     = "{}"
  description = "Resource policy to apply to the secret stored in the AWS Secrets Manager"
}

variable "secretsmanager_delete_after_days" {
  type        = number
  default     = 0
  description = "Number of days to wait before deleting the secret from Secretsmanager. It should be between 7 to 30 but can be set to 0 to delete the key immediately"
}

variable "secretsmanager_enable_auto_rotation" {
  type        = bool
  default     = true
  description = "Whether Secrets Manager should enable auto password rotation for the database"
}

variable "secretsmanager_rotate_after_days" {
  type        = number
  default     = 30
  description = "After how many days Secrets Manager should rotate the database password"
}

variable "secretsmanager_lambda_tracing_mode" {
  type        = string
  default     = "PassThrough"
  description = "Enable X-Ray tracing in either `PassThrough` or `Active` mode"
}

variable "secretsmanager_lambda_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnets IDs where you want to deploy the Secrets Manager's credentials rotator lambda function. **Note:** Required if `use_secretsmanager` is set to true"
}

variable "secretsmanager_lambda_sg_ids" {
  type        = list(string)
  default     = []
  description = "ID od Security Groups that you want to attach to Secrets Manager's credentials rotator lambda function. **Note:** Leave it blank to auto-create one"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to associate with the resources created by this module"
}
