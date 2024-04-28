variable "main_cidr_block" {
  description = "Main CIDR Block for All Regions"
  default     = "10.0.0.0/8"
}

variable "aws_region_list_for_cidr" {
  description = "AWS Region List for creating CIDR Blocks"
  default = {
    "ap-southeast-1" = 0
    "ap-south-1"     = 1
    "us-west-2"      = 2
    "ap-south-2"     = 3
  }
}

variable "server_tag_value" {
  description = "Tag Value for server"
  default     = "devsecops-jenkins"
}

variable "environment" {
  description = "Env Value for server"
  default     = "dev"
}

variable "staging_ec2_key_name" {
  description = "Staging Server EC2 Key Name"
  default     = "devsecops-jenkins"
}

variable "configs_bucket_name" {
  description = "Storage Bucket for Config files"
  default     = "config-files-amk-152"
}

variable "staging_spot_instance_types" {
  description = "Spot Instance Types for staging server"
  type        = list(string)
  default     = ["t4g.xlarge"]
}

variable "machine_type" {
  description = "Machine Architecture"
  default     = "arm64"
}

variable "subscription_emails" {
  description = "Create Topic Subscriptions with these emails for current region"
  type        = list(string)
  default     = ["aungmyatkyaw.kk@gmail.com"]
}

variable "istio_ingress_gateway_nodeport" {
  description = "NodePort Number for Istio Ingress Gateway"
  type        = number
  default     = 30593
}

variable "cloudflare_api_token" {
  description = "API Token for cloudflare"
  type        = string
}

variable "cloudflare_website_name" {
  description = "Website name"
  type        = string
  default     = "aungmyatkyaw.site"
}
