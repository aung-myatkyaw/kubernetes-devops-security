// Store Terraform Backend State on S3 Bucket
terraform {
  backend "s3" {
    bucket         = "terraform-backend-state-amk-152"
    key            = "devsecops-jenkins/backend-state"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform_state_locks"
    encrypt        = true
    profile        = "amk"
  }
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

// Define Provider and Region
provider "aws" {
  region  = "ap-south-1"
  profile = "amk"
  alias   = "mumbai"
  default_tags {
    tags = {
      Project = "DevSecOps-Jenkins"
    }
  }
}

// Define Provider and Region
provider "aws" {
  region  = "ap-southeast-1"
  profile = "amk"
  default_tags {
    tags = {
      Project = "DevSecOps-Jenkins"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
