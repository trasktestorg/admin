variable "repository_id" {}
variable "pattern" {}

variable required_pull_request_reviews { default = true }
variable "required_approving_review_count" { default = 1 }
variable "require_code_owner_reviews" { default = true }
variable "restrict_dismissals" { default = false }
variable "pull_request_bypassers" { default = [] }

variable "required_status_checks" { default = true }
variable "required_status_checks_no_easy_cla" { default = false }
variable "required_status_checks_strict" { default = true }
variable "additional_required_status_checks" { default = [] }

variable "require_conversation_resolution" { default = false }
variable "required_linear_history" { default = false }

variable "lock_branch" { default = false }
variable "enforce_admins" { default = true }

variable "restrict_pushes" { default = true }
variable "block_creations" { default = false }
variable "push_allowances" { default = [] }

variable "allows_force_pushes" { default = false }
variable "allows_deletion" { default = false }

variable "force_push_bypassers" { default = [] }

resource "github_branch_protection" "this" {
  repository_id = var.repository_id
  pattern       = var.pattern

  dynamic "required_pull_request_reviews" {
    for_each = var.required_pull_request_reviews ? [1] : []
    content {
      required_approving_review_count = var.required_approving_review_count
      dismiss_stale_reviews           = false
      require_code_owner_reviews      = var.require_code_owner_reviews
      restrict_dismissals             = var.restrict_dismissals
      dismissal_restrictions          = []
      pull_request_bypassers          = var.pull_request_bypassers
      require_last_push_approval      = false
    }
  }
  dynamic "required_status_checks" {
    for_each = var.required_status_checks ? [1] : []
    content {
      strict   = var.required_status_checks_strict
      contexts = concat(["EasyCLA"], var.additional_required_status_checks)
    }
  }
  dynamic "required_status_checks" {
    for_each = var.required_status_checks_no_easy_cla ? [1] : []
    content {
      strict   = var.required_status_checks_strict
      contexts = var.additional_required_status_checks
    }
  }
  require_conversation_resolution = var.require_conversation_resolution
  require_signed_commits          = false
  required_linear_history         = var.required_linear_history

  # merge queue configuration isn't supported by the terraform provider yet

  lock_branch    = var.lock_branch
  enforce_admins = var.enforce_admins

  dynamic "restrict_pushes" {
    for_each = var.restrict_pushes ? [1] : []
    content {
      blocks_creations = var.block_creations
      push_allowances  = var.push_allowances
    }
  }

  allows_force_pushes = var.allows_force_pushes
  allows_deletions    = var.allows_deletion

  force_push_bypassers = var.force_push_bypassers
}
