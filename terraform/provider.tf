terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 5.0"
    }
    ansible = {
      source = "ansible/ansible"
      # version = "1.2.0"
    }
  }
  # Configure an S3 bucket as the backend for the Terraform state file. This will store the Terraform state file securely in an S3 bucket.
  backend "s3" {
    bucket         = "dev-statefile-2025"    # Replace with your bucket name
    key            = "terraform.tfstate"   # Replace with your state file name
    region         = "us-east-1"      # Replace with your bucket region
    use_lockfile   = true         # To enable locking for the state file in the S3 bucket. This will prevent concurrent modifications to the state file.
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "Admin"
}