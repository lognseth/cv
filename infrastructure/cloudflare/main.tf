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

resource "cloudflare_dns_record" "www_redirect" {
  zone_id = cloudflare_pages_domain.resume["mikael.cv"].zone_tag
  name    = "www.mikael.cv"
  type    = "A"
  content = "192.0.2.1"
  proxied = true
  ttl     = 1

  comment = "Originless hostname for the www to apex redirect"
}

resource "cloudflare_ruleset" "www_redirect" {
  zone_id     = cloudflare_pages_domain.resume["mikael.cv"].zone_tag
  name        = "Canonical hostname redirects"
  description = "Redirect alternate hostnames to mikael.cv"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = [{
    ref         = "redirect_www_to_apex"
    description = "Redirect www.mikael.cv to mikael.cv"
    expression  = "(http.host eq \"www.mikael.cv\")"
    action      = "redirect"
    action_parameters = {
      from_value = {
        status_code           = 301
        preserve_query_string = true
        target_url = {
          expression = "concat(\"https://mikael.cv\", http.request.uri.path)"
        }
      }
    }
  }]
}
