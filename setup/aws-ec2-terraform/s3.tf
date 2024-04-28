// Configurations Bucket for Singapore Region
data "aws_s3_bucket" "config_bucket" {
  bucket = var.configs_bucket_name
}
