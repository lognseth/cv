resource "cloudflare_pages_project" "resume" {
  account_id        = var.cloudflare_account_id
  name              = var.project_name
  production_branch = var.production_branch
}

resource "cloudflare_pages_domain" "resume" {
  for_each = var.domains

  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.resume.name
  name         = each.value
}

