# Create a managed database using AWS RDS

Supports: MySQL, Postgres, MariaDB, Oracle & MS-SQL

This terraform module will deploy the following services:
- RDS
  - Database
  - Subnet Group (optional)
- IAM Role (optional)
- Random Password (optional)
- SSM Parameter (optional)

## Licence:
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

MIT Licence. See [Licence](LICENCE) for full details.

# Usage Instructions:
## Example
```terraform
module "db" {
  source = "github.com/terrablocks/aws-rds.git"

  sg_ids = []
}
```
## Variables
| Parameter                             | Type    | Description                                                                                                                                                         | Default                | Required |
|---------------------------------------|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------|----------|
| engine                                | string  | Database engine (mysql, postgres, mariadb, oracle or sqlserver)                                                                                                     | mysql                  | N        |
| engine_version                        | string  | Database engine version                                                                                                                                             | 5.7                    | N        |
| instance_name                         | string  | Name of RDS instance                                                                                                                                                | mysql-db               | N        |
| random_password                       | boolean | Whether to generate random password. This password will be stored in SSM Parameter Store as a `SecureString`                                                                                                                                 | true                   | N        |
| db_username                           | string  | Master username for RDS instance                                                                                                                                    | dbadmin                  | N        |
| db_password                           | string  | Master password for RDS instance. This password will be stored in SSM Parameter Store as a `SecureString`. **Required if random_password is set to false**                                                                                   |                        | N        |
| instance_type                         | string  | Instance type for RDS                                                                                                                                               | db.t3.medium           | N        |
| ca_cert                               | string  | Root CA cert to be used for in-transit encryption.                                                                                                                  | rds-ca-2019            | N        |
| storage_type                          | string  | Type of storage to be used for RDS instance                                                                                                                         | gp2                    | N        |
| storage_size                          | number  | Size of EBS storage                                                                                                                                                 | 20                     | N        |
| iops                                  | number  | IOPS for EBS storage. **Required only for io1 volume**                                                                                                              | 0                      | N        |
| max_allocated_storage                 | number  | Enable storage auto-scaling feature. To disable provide 0 as value                                                                                                  | 1000                   | N        |
| multi_az                              | boolean | Whether to deploy a multi-az database                                                                                                                               | true                   | N        |
| subnet_group_name                     | string  | Database subnet group to be used while launching database. **Either of subnet_group_name or subnet_ids is required**                                                    |                        | N        |
| subnet_ids                            | list    | Subnet IDs to be used for launching database. **Either of subnet_group_name or subnet_ids is required**                                                                                                                        | []                     | N        |
| publicly_accessible                   | boolean | Whether to allow access from outside world                                                                                                                          | false                  | N        |
| sg_ids                                | list    | List of security groups to be attached to RDS instance                                                                                                              | []                     | Y        |
| db_port                               | number  | Port on which database should accept incoming connections                                                                                                           | 3306                   | N        |
| db_name                               | string  | Name of the default database to be created                                                                                                                          |                        | N        |
| parameter_group_name                  | string  | Parameter group name to be used for database                                                                                                                        | default.mysql5.7       | N        |
| option_group_name                     | string  | Option group name to be used for database                                                                                                                           | default:mysql-5-7      | N        |
| storage_encrypted                     | boolean | Whether to apply server-side encryption                                                                                                                             | true                   | N        |
| db_kms_key                            | string  | KMS key to use for server-side encryption                                                                                                                           | alias/aws/rds          | N        |
| ssm_kms_key                           | string  | KMS key to store encrypted password in AWS SSM Parameter store service                                                                                              | alias/aws/ssm          | N        |
| backup_retention_period               | number  | No. of days to retain automated backups                                                                                                                             | 7                      | N        |
| backup_window                         | string  | The time period when backup activity must be performed                                                                                                              |                        | N        |
| copy_tags_to_snapshot                 | boolean | Whether to copy RDS tags to snapshot                                                                                                                                | true                   | N        |
| monitoring_interval                   | number  | To enable detailed monitoring provide interval in seconds. Valid Values: 1, 5, 10, 15, 30, 60. 0 disables detailed monitoring          | 0                      | N        |
| cw_log_exports                        | list    | List of logs to be exported to cloudwatch logs                                                                                                                      | []                     | N        |
| auto_minor_version_upgrade            | boolean | Whether to update minor version of database if available                                                                                                            | true                   | N        |
| maintenance_window                    | string  | The time period when maintenance activity must be performed                                                                                                         |                        | N        |
| skip_final_snapshot                   | boolean | Whether to skip final snapshot when terminating database                                                                                                            | false                  | N        |
| final_snapshot_identifier             | string  | Name of final snapshot                                                                                                                                              | db-final-snapshot      | N        |
| deletion_protection                   | boolean | Option to prevent accidental deletion of RDS instance                                                                                                               | true                   | N        |
| enable_iam_auth                   | boolean | Whether to enable IAM authetication feature for database                       | false                   | N        |
| performance_insights_enabled          | boolean | Whether to enable performance insights                                                                                                                              | true                  | N        |
| performance_insights_kms_key          | string  | KMS key to be used for encrypting database insight data                                                                                                             | alias/aws/rds          | N        |
| performance_insights_retention_period | number  | No. of days to retain insights data                                                                                                                                 | 7                      | N        |
| db_license                            | string  | Type of license required to use the database. Valid values: license-included, bring-your-own-license. **Required only for Oracle database** | bring-your-own-license | N        |
| character_set                         | string  | Character set to be used for database. **Required only for Oracle database**                                                                                        | UTF8                   | N        |
| ad_domain_id                          | string  | Active Directory domain ID to connect to MS-SQL database. **Required only for MS-SQL Server**                                                                       |                        | N        |
| timezone                              | string  | Timezone to be set for database. **Required only for MS-SQL Server**                                                                                                |                        | N        |
| snapshot_id                           | string  | If you want to restore a snapshot or create database from an existing snapshot please provide the snapshot ID                                                       |                        | N        |
| apply_immediately    | boolean  | Apply database changes immediately instead of waiting until next maintenance windows    | false     | N        |
| tags                  | map  | Map of tags to associate with db instance                               |                        | N        |

## Outputs
| Parameter            | Type   | Description                                                      |
|----------------------|--------|------------------------------------------------------------------|
| db_endpoint          | string | Endpoint of database                                                |
| db_username          | string | Master username of database                                                |
| db_password_ssm      | string | Name of SSM Parameter used for storing database password                                      |
| db_name          | string | Name of default database created by RDS                                                |
| db_id          | string | Instance ID of RDS database                                                |

## Deployment
- `terraform init` - download plugins required to deploy resources
- `terraform plan` - get detailed view of resources that will be created, deleted or replaced
- `terraform apply` - deploy the template without confirmation (non-interactive mode)
- `terraform destroy` - terminate all the resources created using this template without confirmation (non-interactive mode)
