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

resource "cloudflare_dns_record" "resume" {
  for_each = var.domains

  zone_id = cloudflare_pages_domain.resume[each.value].zone_tag
  name    = each.value
  type    = "CNAME"
  content = cloudflare_pages_project.resume.subdomain
  proxied = true
  ttl     = 1

  comment = "Cloudflare Pages custom domain managed by Terraform"
}
