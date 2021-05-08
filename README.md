# Create a managed database using AWS RDS

Supports: MySQL, Postgres, MariaDB, Oracle & MS-SQL

![License](https://img.shields.io/github/license/terrablocks/aws-rds?style=for-the-badge) ![Tests](https://img.shields.io/github/workflow/status/terrablocks/aws-rds/tests/master?label=Test&style=for-the-badge) ![Checkov](https://img.shields.io/github/workflow/status/terrablocks/aws-rds/checkov/master?label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-rds?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-rds?style=for-the-badge)

This terraform module will deploy the following services:
- RDS
  - Database
  - Subnet Group (optional)
- IAM Role (optional)
- Random Password (optional)
- SSM Parameter (optional)

# Usage Instructions
## Example
```terraform
module "db" {
  source = "github.com/terrablocks/aws-rds.git"

  sg_ids = ["sg-xxxx"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.37.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| engine | Visit https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html for engine type | `string` | `"mysql"` | no |
| engine_version | Visit https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html for engine version | `string` | `"8.0.23"` | no |
| instance_name | Name of RDS instance | `string` | `"mysql-db"` | no |
| random_password | Whether to generate random password. This password will be stored in SSM Parameter Store as a `SecureString` | `bool` | `true` | no |
| db_username | Master username for RDS instance | `string` | `"dbadmin"` | no |
| db_password | Master password for RDS instance. This password will be stored in SSM Parameter Store as a `SecureString`. **Note:** Required if random_password is set to false | `string` | `""` | no |
| instance_type | Instance type for RDS database | `string` | `"db.t3.medium"` | no |
| ca_cert | Root CA cert to be used for in-transit encryption | `string` | `"rds-ca-2019"` | no |
| storage_type | Type of storage to be used for RDS instance | `string` | `"gp2"` | no |
| storage_size | Size of EBS storage attached to database | `number` | `50` | no |
| iops | IOPS for EBS storage. **Note:** Required only for io1 volume | `number` | `0` | no |
| max_allocated_storage | Enable storage auto-scaling feature. To disable provide 0 as value | `number` | `1000` | no |
| multi_az | Whether to deploy a multi-az database | `bool` | `true` | no |
| subnet_group_name | Database subnet group to be used while launching database. **Note:** Either of subnet_group_name or subnet_ids is required | `string` | `""` | no |
| subnet_ids | Subnet IDs to be used for launching database. **Note:** Either of subnet_group_name or subnet_ids is required | `list(string)` | `[]` | no |
| publicly_accessible | Whether to allow access from outside world | `bool` | `false` | no |
| sg_ids | List of security groups to be attached to RDS instance | `list(string)` | n/a | yes |
| db_port | Port on which database should accept incoming connections | `number` | `3306` | no |
| db_name | Name of the default database to be created | `string` | `""` | no |
| parameter_group_name | Parameter group name to be used for database | `string` | `"default.mysql8.0"` | no |
| option_group_name | Option group name to be used for database | `string` | `"default:mysql-8-0"` | no |
| storage_encrypted | Whether to apply server-side encryption | `bool` | `true` | no |
| db_kms_key | KMS key to use for server-side encryption | `string` | `"alias/aws/rds"` | no |
| ssm_kms_key | KMS key to store encrypted password in AWS SSM Parameter store service | `string` | `"alias/aws/ssm"` | no |
| backup_retention_period | Number of days to retain automated backups | `number` | `7` | no |
| backup_window | The time period when backup activity must be performed | `string` | `""` | no |
| copy_tags_to_snapshot | Whether to copy RDS tags to snapshot | `bool` | `true` | no |
| monitoring_interval | To enable detailed monitoring provide interval in seconds. Valid Values: 0, 1, 5, 10, 15, 30, 60. 0 wil disable detailed monitoring | `number` | `0` | no |
| cw_log_exports | List of logs to be exported to cloudwatch logs | `list(string)` | `[]` | no |
| auto_minor_version_upgrade | Whether to update minor version of database if available | `bool` | `true` | no |
| maintenance_window | The time period when maintenance activity must be performed | `string` | `""` | no |
| skip_final_snapshot | Whether to skip final snapshot when terminating database | `bool` | `false` | no |
| final_snapshot_identifier | Name of final snapshot that will be created before deleting database | `string` | `"db-final-snapshot"` | no |
| deletion_protection | Option to prevent accidental deletion of RDS instance | `bool` | `true` | no |
| enable_iam_auth | Whether to enable IAM authetication feature for database | `bool` | `false` | no |
| performance_insights_enabled | Whether to enable performance insights | `bool` | `true` | no |
| performance_insights_kms_key | KMS key to be used for encrypting database insight data | `string` | `"alias/aws/rds"` | no |
| performance_insights_retention_period | Number of days to retain performance insights data | `number` | `7` | no |
| db_license | Type of license required to use the database. Valid values: license-included, bring-your-own-license. **Note:** Required only for Oracle database | `string` | `"bring-your-own-license"` | no |
| character_set | Character set to be used for database. **Note:** Required only for Oracle database | `string` | `"UTF8"` | no |
| ad_domain_id | Active Directory domain ID to connect to MS-SQL database. **Note:** Required only for MS-SQL Server | `string` | `""` | no |
| timezone | Timezone to be set for database. **Note:** Required only for MS-SQL Server | `string` | `""` | no |
| snapshot_id | If you want to restore a snapshot or create database from an existing snapshot please provide the snapshot ID | `string` | `""` | no |
| apply_immediately | Apply database changes immediately instead of waiting until next maintenance windows | `bool` | `false` | no |
| allow_major_version_upgrade | Indicates that major version upgrades are allowed | `bool` | `false` | no |
| tags | Map of tags to associate with db instance | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint | Endpoint of database in `address:port` format |
| address | The hostname of the RDS instance |
| port | Port at which RDS database is listening for traffic |
| username | Master username of database |
| password_ssm | Name of SSM Parameter used for storing database password |
| name | Name of default database created by RDS |
| id | ID of RDS database instance |
| arn | ARN of RDS database instance |
| resource_id | Resource ID of RDS database instance |
| hosted_zone_id | Canonical hosted zone ID of RDS database instance |
