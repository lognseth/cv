terraform {
  required_version = ">= 1.8.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.20"
    }
  }

  # Backend settings and credentials are supplied at initialization time.
  backend "s3" {}
}
