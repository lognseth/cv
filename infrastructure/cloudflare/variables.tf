variable "cloudflare_account_id" {
  description = "Cloudflare account containing mikael.cv."
  type        = string
}

variable "project_name" {
  description = "Cloudflare Pages project name."
  type        = string
  default     = "mikael-cv"
}

variable "production_branch" {
  description = "Branch deployed to the production Pages environment."
  type        = string
  default     = "main"
}

variable "domains" {
  description = "Domains attached to the Pages project."
  type        = set(string)
  default     = ["mikael.cv", "www.mikael.cv"]
}

