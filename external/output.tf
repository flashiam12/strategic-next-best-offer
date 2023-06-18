output "aws_rds_db_id" {
  value = module.db.db_instance_id
}
output "aws_rds_db_name" {
  value = module.db.db_instance_name
}
output "aws_rds_db_username" {
  value = module.db.db_instance_username
}
output "aws_rds_db_password" {
  value = module.db.db_instance_password
}
output "aws_rds_db_address" {
  value = module.db.db_instance_address
}
output "aws_rds_db_port" {
  value = module.db.db_instance_port
}

