variable "name" {}
variable "description" { default = "" }
variable "homepage_url" { default = "https://opentelemetry.io" }
variable "topics" { default = [] }

variable "has_wiki" { default = false }
variable "has_issues" { default = true }
variable "has_discussions" { default = false }
variable "has_projects" { default = false }

variable "allow_merge_commit" { default = false }
variable "allow_squash_merge" { default = true }
variable "allow_rebase_merge" { default = false }

variable "squash_merge_commit_title" { default = "COMMIT_OR_PR_TITLE" }
variable "squash_merge_commit_message" { default = "COMMIT_MESSAGES" }
variable "merge_commit_title" { default = "MERGE_MESSAGE" }
variable "merge_commit_message" { default = "PR_TITLE" }

variable "allow_update_branch" { default = false }
variable "allow_auto_merge" { default = false }
variable "delete_branch_on_merge" { default = true }

variable "vulnerability_alerts" { default = true }
variable "secret_scanning_status" { default = "disabled" }
variable "secret_scanning_push_protection_status" { default = "disabled" }

variable "has_pages" { default = false }
variable "pages_source_branch" { default = "gh-pages" }
variable "pages_build_type" { default = "legacy" }
variable "pages_path" { default = "/" }

variable "archived" { default = false }
variable "visibility" { default = "public" }

// TODO change default to [] once all repos are converted to the EasyCLA ruleset
variable "easycla_branch_exclusions" {
  default = null
  type = list(string)
}

// TODO change default to [] once all repos are converted to the branch creation restriction ruleset
variable "release_branches" {
  default = null
  type = list(string)
}

resource "github_repository" "this" {
  name = var.name

  description = var.description
  homepage_url = var.homepage_url
  topics = var.topics

  is_template                 = false
  web_commit_signoff_required = false

  has_wiki        = var.has_wiki
  has_issues      = var.has_issues
  has_discussions = var.has_discussions
  has_projects    = var.has_projects

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge

  squash_merge_commit_title = var.squash_merge_commit_title
  squash_merge_commit_message = var.squash_merge_commit_message
  merge_commit_title = var.merge_commit_title
  merge_commit_message = var.merge_commit_message

  allow_update_branch    = var.allow_update_branch
  allow_auto_merge       = var.allow_auto_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  vulnerability_alerts = var.vulnerability_alerts && !var.archived

  security_and_analysis {
    secret_scanning {
      status = var.secret_scanning_status
    }
    secret_scanning_push_protection {
      status = var.secret_scanning_push_protection_status
    }
  }

  dynamic "pages" {
    for_each = var.has_pages ? [1] : []
    content {
      build_type = var.pages_build_type
      source {
        branch = var.pages_source_branch
        path = var.pages_path
      }
    }
  }

  archived = var.archived
  visibility = var.visibility

  # deprecated
  has_downloads = true

  # extra safety (PAT doesn't have delete_repo permission anyways)
  archive_on_destroy = true
}

resource "github_repository_ruleset" "easycla" {
  // TODO gate this on the repo being public once it's applied to all repos
  count = var.easycla_branch_exclusions != null ? 1 : 0

  name        = "EasyCLA"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  dynamic "conditions" {
    for_each = length(var.easycla_branch_exclusions) > 0 ? [1] : []
    content {
      ref_name {
        exclude = var.easycla_branch_exclusions
        include = []
      }
    }
  }

  rules {
    required_status_checks {
      required_check {
        context = "EasyCLA"
        integration_id = 17893
      }
      strict_required_status_checks_policy = false
      do_not_enforce_on_create = true
    }
  }
}

resource "github_repository_ruleset" "branch_creation_restriction" {
  // TODO remove gating once all repos have onboarded
  count = var.easycla_branch_exclusions != null && var.release_branches != null ? 1 : 0

  name        = "Branch creation restriction"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      exclude = concat(var.easycla_branch_exclusions, var.release_branches)
      include = []
    }
  }

  rules {
    creation = true
  }
}

output "node_id" {
  value = github_repository.this.node_id
}
