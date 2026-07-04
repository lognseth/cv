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

