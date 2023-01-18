# Create a managed database using AWS RDS

Supports: MySQL, Postgres, MariaDB, Oracle & MS-SQL

![License](https://img.shields.io/github/license/terrablocks/aws-rds?style=for-the-badge) ![Tests](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-rds/tests.yml?branch=main&label=Test&style=for-the-badge) ![Checkov](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-rds/checkov.yml?branch=main&label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-rds?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-rds?style=for-the-badge)

This terraform module will deploy the following services:
- RDS
  - Database
  - Subnet Group (optional)
- IAM Role (optional)
- Random Password (optional)
- SSM Parameter (optional)
- Secrets Manager (optional)
- Lambda Function (optional)

# Usage Instructions
## Example
```terraform
module "db" {
  source = "github.com/terrablocks/aws-rds.git"

  db_subnet_ids     = ["subnet-xxxxxxxxxxx"]
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
| engine_version | Visit https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html for engine version | `string` | `"8.0.27"` | no |
| instance_name | Name of the RDS instance | `string` | `"mysql-db"` | no |
| random_password | Whether to generate a random password for the database. This password will be stored in SSM Parameter Store as a `SecureString` or in Secrets Manager depending on your choice | `bool` | `true` | no |
| db_username | Master username for the RDS instance | `string` | `"dbadmin"` | no |
| db_password | Master password for the RDS instance. This password will be stored in SSM Parameter Store as a `SecureString` or in Secrets Manager depending on your choice. **Note:** Required if random_password is set to false | `string` | `""` | no |
| instance_type | Instance type for the RDS database | `string` | `"db.t3.medium"` | no |
| ca_cert | Root CA cert to use for in-transit encryption between the server and the RDS instance | `string` | `"rds-ca-2019"` | no |
| storage_type | Type of storage to use for the RDS instance | `string` | `"gp2"` | no |
| storage_size | Size of the EBS storage attached to database | `number` | `50` | no |
| iops | IOPS for the EBS storage. **Note:** Required only for io1 volume | `number` | `0` | no |
| max_allocated_storage | Enable storage auto-scaling feature for the RDS instance. To disable set this to 0 | `number` | `1000` | no |
| multi_az | Whether to deploy a multi-az database | `bool` | `true` | no |
| db_subnet_group_name | Database subnet group to use while launching the database. **Note:** Either of `db_subnet_group_name` or `db_subnet_ids` is required | `string` | `""` | no |
| db_subnet_ids | Subnet IDs to use for creating a subnet group. **Note:** Either of `db_subnet_group_name` or `db_subnet_ids` is required | `list(string)` | `[]` | no |
| publicly_accessible | Whether to allow database access over the public internet | `bool` | `false` | no |
| db_sg_ids | List of security groups ID to attach to the RDS instance. **Note:** Leave it blank to auto-create one and attach it to the RDS instance | `list(string)` | `[]` | no |
| db_port | Port on which database should accept incoming connections | `number` | `3306` | no |
| db_name | Name of the default database to create | `string` | `""` | no |
| parameter_group_name | Parameter group name to use for database | `string` | `"default.mysql8.0"` | no |
| option_group_name | Option group name to use for database | `string` | `"default:mysql-8-0"` | no |
| storage_encrypted | Whether to enable server-side encryption for the RDS instance | `bool` | `true` | no |
| db_kms_key | KMS key to use for server-side encryption | `string` | `"alias/aws/rds"` | no |
| backup_retention_period | Number of days to retain automated backups | `number` | `7` | no |
| backup_window | The time period when backup activity will be performed | `string` | `null` | no |
| copy_tags_to_snapshot | Whether to copy the RDS tags to the snapshot | `bool` | `true` | no |
| monitoring_interval | To enable detailed monitoring provide interval in seconds. Valid Values: 0, 1, 5, 10, 15, 30, 60. 0 will disable detailed monitoring | `number` | `0` | no |
| cw_log_exports | List of logs to be exported to the cloudwatch logs | `list(string)` | `[]` | no |
| auto_minor_version_upgrade | Whether to update minor version of database if available | `bool` | `true` | no |
| maintenance_window | The time period when maintenance activity will be performed | `string` | `null` | no |
| skip_final_snapshot | Whether to skip final snapshot before terminating the RDS instance | `bool` | `false` | no |
| final_snapshot_identifier | Name of final snapshot to create before deleting the RDS instance | `string` | `"db-final-snapshot"` | no |
| deletion_protection | Whether to prevent accidental deletion of RDS instance | `bool` | `true` | no |
| enable_iam_auth | Whether to enable IAM authetication feature for the RDS instance | `bool` | `false` | no |
| performance_insights_enabled | Whether to enable performance insights for the RDS instance | `bool` | `true` | no |
| performance_insights_kms_key | KMS key to use for encrypting database insight data | `string` | `"alias/aws/rds"` | no |
| performance_insights_retention_period | Number of days to retain performance insights data | `number` | `7` | no |
| db_license | Type of license required to use the database. Valid values: license-included, bring-your-own-license. **Note:** Required only for Oracle database | `string` | `"bring-your-own-license"` | no |
| character_set | Character set to use for the database. **Note:** Required only for Oracle database | `string` | `"UTF8"` | no |
| ad_domain_id | Active Directory domain ID to connect to the MS-SQL database. **Note:** Required only for the MS-SQL Server | `string` | `null` | no |
| timezone | Timezone to set for the database. **Note:** Required only for the MS-SQL Server | `string` | `null` | no |
| snapshot_id | If you want to restore a snapshot or create database from an existing snapshot please provide the snapshot ID | `string` | `null` | no |
| apply_immediately | Apply database changes immediately instead of waiting until next maintenance windows | `bool` | `false` | no |
| allow_major_version_upgrade | Indicates that major version upgrades are allowed | `bool` | `false` | no |
| use_ssm | Use SSM Parameter Store to securely store the database password | `bool` | `false` | no |
| ssm_kms_key | KMS key to use for encrypting the password in AWS SSM Parameter Store service | `string` | `"alias/aws/ssm"` | no |
| use_secretsmanager | Use Secrets Manager to securely store the database password | `bool` | `true` | no |
| secretsmanager_kms_key | KMS key to use for encrypting the password in AWS Secrets Manager service | `string` | `"alias/aws/secretsmanager"` | no |
| secretsmanager_policy | Resource policy to apply to the secret stored in the AWS Secrets Manager | `string` | `"{}"` | no |
| secretsmanager_delete_after_days | Number of days to wait before deleting the secret from Secretsmanager. It should be between 7 to 30 but can be set to 0 to delete the key immediately | `number` | `0` | no |
| secretsmanager_enable_auto_rotation | Whether Secrets Manager should enable auto password rotation for the database | `bool` | `true` | no |
| secretsmanager_rotate_after_days | After how many days Secrets Manager should rotate the database password | `number` | `30` | no |
| secretsmanager_lambda_tracing_mode | Enable X-Ray tracing in either `PassThrough` or `Active` mode | `string` | `"PassThrough"` | no |
| secretsmanager_lambda_subnet_ids | Subnets IDs where you want to deploy the Secrets Manager's credentials rotator lambda function. **Note:** Required if `use_secretsmanager` is set to true | `list(string)` | `[]` | no |
| secretsmanager_lambda_sg_ids | ID od Security Groups that you want to attach to Secrets Manager's credentials rotator lambda function. **Note:** Leave it blank to auto-create one | `list(string)` | `[]` | no |
| tags | Map of tags to associate with the resources created by this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| endpoint | Endpoint of database in `address:port` format |
| address | The hostname of the RDS instance |
| port | Port at which RDS database is listening for traffic |
| username | Master username of database |
| name | Name of default database created by RDS |
| id | ID of RDS database instance |
| arn | ARN of RDS database instance |
| resource_id | Resource ID of RDS database instance |
| hosted_zone_id | Canonical hosted zone ID of RDS database instance |
| password_ssm_name | Name of SSM Parameter used for storing database password. **Note:** Available only if `use_ssm` is set to true |
| password_ssm_arn | ARN of SSM Parameter used for storing database password. **Note:** Available only if `use_ssm` is set to true |
| password_secretsmanager_arn | ARN of Secrets Manager used for storing database password. **Note:** Available only if `use_secretsmanager` is set to true |
| secretsmanager_lambda_name | Name of lambda function created to rotate database credentials automatically. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true |
| secretsmanager_lambda_arn | ARN of lambda function created to rotate database credentials automatically. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true |
| secretsmanager_lambda_sg_ids | ID of security groups attached to the rotator lambda function. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true |
| secretsmanager_lambda_role_name | Name of IAM role attached to the rotator lambda function. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true |
| secretsmanager_lambda_role_arn | ARN of IAM role attached to the rotator lambda function. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true |
