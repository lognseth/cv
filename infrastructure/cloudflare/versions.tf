terraform {
  required_version = ">= 1.8.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.20"
    }
  }

  # Production initialization supplies the R2 settings from backend.hcl.
  # For validation without credentials, use: terraform init -backend=false
  backend "s3" {}
}

