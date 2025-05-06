terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }
  }

  required_version = ">= 1.0.0"

  backend "s3" {
    bucket         = "ecom-biekro-bucket"
    key            = "terraform.tfstate"
    region         = var.region        # Change to your desired region
    dynamodb_table = "ecom-biekro-table" # Optional, for state locking
    encrypt        = true                # Optional, for server-side encryption    
  }
}