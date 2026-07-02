variable "repository_owner" {
  description = "GitHub user or organization that owns the repository."
  type        = string
  default     = "mathieusouflis"
}

variable "repository_name" {
  description = "Name of the repository to configure."
  type        = string
  default     = "github-template"
}

variable "ci_required_status_checks" {
  description = "Job names (as they appear under `name:` in .github/workflows/ci.yml) that must pass before merging into main."
  type        = list(string)
  default     = ["Lint & type-check", "Tests", "Build"]
}
