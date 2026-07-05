# mikael.cv

My résumé, and the infrastructure that publishes it.

[mikael.cv](https://mikael.cv) is a dependency-light static site hosted on Cloudflare Pages. The Pages project and its custom domains are described with Terraform; GitHub Actions checks, provisions, and deploys the project.

```text
GitHub repository
  ├── pull request ──> site checks + Terraform validation
  ├── main branch ───> Wrangler ──> Cloudflare Pages ──> mikael.cv
  └── manual IaC ────> Terraform ──> Cloudflare API
                              └────> private state in Cloudflare R2
```

## Design decisions

- **Static by default.** The résumé uses semantic HTML and CSS with one nonessential line of JavaScript. There is no application server, framework runtime, or client-side tracking.
- **Infrastructure is reviewable.** Terraform owns the Pages project and domain attachments. Infrastructure changes are planned or applied through a protected GitHub environment.
- **Deployment is explicit.** The site uses Pages Direct Upload through Wrangler, so the complete deployment path lives in this repository rather than an opaque dashboard integration.
- **State stays private.** Terraform state is stored in a private R2 bucket through its S3-compatible API. State and credentials are ignored by Git.
- **Security without theatre.** Cloudflare Pages supplies TLS and the site adds a restrictive content security policy, clickjacking protection, a permissions policy, and conservative referrer handling.

## Repository layout

```text
site/                       Static résumé and Cloudflare headers/redirects
infrastructure/cloudflare/  Terraform configuration
.github/workflows/          Validation, infrastructure, and deployment jobs
```

## Bootstrap

The domain already uses Cloudflare DNS. The remaining one-time setup is intentionally small:

1. Apply `cloudflare_r2_bucket.terraform_state` once with the local backend.
2. Create bucket-scoped R2 credentials with Object Read & Write access.
3. Migrate the bootstrap state into R2 with `terraform init -migrate-state -backend-config=backend.hcl`.
4. Create a least-privilege Cloudflare API token that can edit Pages and the `mikael.cv` zone.
5. Add the secrets listed below to the GitHub `production` environment.
6. Run the **Infrastructure** workflow with `plan`, then `apply`, followed by **Deploy site**.

If a Pages project named `mikael-cv` already exists, import it before applying:

```sh
terraform import cloudflare_pages_project.resume <account-id>/mikael-cv
```

## Required GitHub secrets

| Secret | Purpose |
|---|---|
| `CLOUDFLARE_ACCOUNT_ID` | Selects the Cloudflare account and R2 endpoint |
| `CLOUDFLARE_API_TOKEN` | Provisions Pages and deploys site assets |
| `R2_ACCESS_KEY_ID` | Reads and writes the remote Terraform state |
| `R2_SECRET_ACCESS_KEY` | Authenticates remote-state access |

Protecting the `production` environment with required review makes infrastructure applies and production deployments deliberate.

## Local development

Serve the `site` directory with any static file server. For example:

```sh
python3 -m http.server --directory site 8000
```

Then visit `http://localhost:8000`.

To initialize against the same R2 backend used by CI:

```sh
cd infrastructure/cloudflare
terraform init -backend-config=backend.hcl
terraform fmt -check
terraform validate
```

## Deployment flow

Pull requests run local link checks and Terraform validation. The check deliberately fails while résumé placeholders remain, preventing an unfinished profile from reaching production. Merges to `main` deploy the contents of `site/` to Cloudflare Pages. Infrastructure changes are separate and manual because DNS and hosting changes deserve an explicit review step.

## Security notes

Secrets are supplied to short-lived GitHub Actions jobs and are never committed. The Cloudflare token should be scoped only to this account and zone. The R2 token should be scoped only to the state bucket. Terraform plan output can contain sensitive values, so plans are not uploaded as public workflow artifacts.
