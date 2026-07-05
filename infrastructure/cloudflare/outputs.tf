output "pages_project" {
  description = "Cloudflare Pages project name."
  value       = cloudflare_pages_project.resume.name
}

output "pages_subdomain" {
  description = "Default Cloudflare Pages address."
  value       = cloudflare_pages_project.resume.subdomain
}

output "custom_domains" {
  description = "Custom domains attached to the project."
  value       = sort([for domain in cloudflare_pages_domain.resume : domain.name])
}

output "dns_records" {
  description = "DNS records routing the custom domains to Cloudflare Pages."
  value = merge(
    { for name, record in cloudflare_dns_record.resume : name => record.content },
    { "www.mikael.cv" = cloudflare_dns_record.www_redirect.content }
  )
}
