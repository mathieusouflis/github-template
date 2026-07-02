output "repository_node_id" {
  description = "GraphQL node ID of the repository."
  value       = github_repository.this.node_id
}

output "repository_full_name" {
  description = "Full \"owner/name\" of the repository."
  value       = github_repository.this.full_name
}

output "repository_html_url" {
  description = "URL of the repository on GitHub."
  value       = github_repository.this.html_url
}
