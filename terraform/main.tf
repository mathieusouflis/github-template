terraform {
  required_version = ">= 1.5.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.12"
    }
  }
}

provider "github" {
  owner = var.repository_owner
  # No token argument here — the provider reads GITHUB_TOKEN from the
  # environment. Run terraform through ./setup.sh, which sources it from
  # `gh auth token` (falling back to an interactive prompt) instead of
  # exporting a token by hand. See README.md.
}

##### GITHUB REPOSITORY #####
module "github_repository" {
  source = "./github-repository"

  repository_name           = var.repository_name
  ci_required_status_checks = var.ci_required_status_checks
}
