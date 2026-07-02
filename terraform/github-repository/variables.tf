variable "repository_name" {
  description = "Name of the repository to configure."
  type        = string
}

variable "ci_required_status_checks" {
  description = "Job names (as they appear under `name:` in .github/workflows/ci.yml) that must pass before merging into main."
  type        = list(string)
  default     = ["Lint & type-check", "Tests", "Build"]
}
