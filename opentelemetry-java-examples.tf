resource "github_repository" "opentelemetry-java-examples" {
  name               = "opentelemetry-java-examples"
  visibility         = "public"
  allow_merge_commit = false
  allow_rebase_merge = false
  has_issues         = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_branch_protection" "opentelemetry-java-examples-main" {
  repository_id = github_repository.opentelemetry-java-examples.node_id
  pattern       = "main"

  required_pull_request_reviews {
    require_code_owner_reviews = true
  }
  enforce_admins = true
  restrict_pushes {
    blocks_creations = true
    push_allowances  = []
  }
}

resource "github_branch_protection" "opentelemetry-java-examples-star" {
  repository_id = github_repository.opentelemetry-java-examples.node_id
  pattern       = "**/**"

  required_pull_request_reviews {
    require_code_owner_reviews = true
  }
  enforce_admins = true
  restrict_pushes {
    blocks_creations = true
    push_allowances  = []
  }
}
