##### REPOSITORY #####
#
# This repository already exists on GitHub, so this resource must be
# imported before the first apply — see README.md. Only the settings this
# config deliberately manages are set below; everything else (description,
# topics, has_issues/has_wiki/..., visibility, is_template, default_branch,
# pages, ...) is left alone via `ignore_changes`. Without that, this
# resource's schema defaults would silently overwrite those fields on the
# first apply even though they're outside what "configure and secure the
# repository" means here.
resource "github_repository" "this" {
  name = var.repository_name

  ### Merge Settings ###
  allow_squash_merge     = true
  allow_rebase_merge     = true
  allow_merge_commit     = false
  allow_auto_merge       = false # every merge is a deliberate, manual action
  delete_branch_on_merge = true

  ### Security ###
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  lifecycle {
    ignore_changes = [
      description,
      homepage_url,
      topics,
      has_issues,
      has_projects,
      has_wiki,
      has_discussions,
      has_downloads,
      visibility,
      is_template,
      archived,
      auto_init,
      gitignore_template,
      license_template,
      default_branch,
      pages,
      allow_update_branch,
      squash_merge_commit_title,
      squash_merge_commit_message,
      merge_commit_title,
      merge_commit_message,
    ]
  }
}

##### BRANCH PROTECTION — MAIN #####
#
# No protection currently exists on main, so this is a clean create, not an
# import. Solo-maintainer defaults: a pull request and passing CI are
# required, but there's no minimum approval count, since GitHub can't let
# you approve your own PR. Admins aren't blanket-enforced, so you can bypass
# in a genuine emergency. Nobody — not a collaborator with push access, not
# a bot — can push directly to main; only repository admins retain that
# ability by default.
resource "github_branch_protection" "main" {
  repository_id = github_repository.this.node_id
  pattern       = "main"

  required_status_checks {
    strict   = true
    contexts = var.ci_required_status_checks
  }

  required_pull_request_reviews {
    required_approving_review_count = 0
  }

  restrict_pushes {
    push_allowances = []
  }

  enforce_admins      = false
  allows_deletions    = false
  allows_force_pushes = false
}

##### ENVIRONMENTS #####
#
# Fixed set — every repo this module manages gets exactly "production" and
# "staging", named to match GitHub Actions environment-scoped secrets/vars
# and any workflow that deploys with `environment: production`/`staging`.
resource "github_repository_environment" "production" {
  environment = "production"
  repository  = github_repository.this.name
}

resource "github_repository_environment" "staging" {
  environment = "staging"
  repository  = github_repository.this.name
}

# Example environment variable (uncomment and adapt):
# resource "github_actions_environment_variable" "example" {
#   repository    = github_repository.this.name
#   environment   = github_repository_environment.production.environment
#   variable_name = "EXAMPLE_VAR"
#   value         = "example-value"
# }

###### COLLABORATORS #####
##
## Authoritative and currently empty — the repo owner is implicit and never
## needs to be listed here. Applying this against a repo with zero
## manually-added collaborators is a no-op. Adding a user later *replaces*
## the entire collaborator set with exactly what's declared, so list
## everyone who should have access, not just the one you're adding.
#resource "github_repository_collaborators" "this" {
#  repository = github_repository.this.name

#  # Example (uncomment and adapt — must be "push" on a personal repository):
#  # user {
#  #   username   = "octocat"
#  #   permission = "push"
#  # }
#}
