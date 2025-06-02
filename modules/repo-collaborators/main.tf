locals {
  # Hardcoded common team IDs (retrieved via gh cli)
  governance_committee_team_id = "11018701"     # governance-committee
  sig_security_maintainers_team_id = "11018568" # sig-security-maintainers

  # Check if governance-committee is explicitly specified in any permission list
  governance_committee_in_admins       = contains(var.admins,       local.governance_committee_team_id)
  governance_committee_in_maintainers  = contains(var.maintainers,  local.governance_committee_team_id)
  governance_committee_in_approvers    = contains(var.approvers,    local.governance_committee_team_id)
  governance_committee_in_triagers     = contains(var.triagers,     local.governance_committee_team_id)
  governance_committee_in_contributors = contains(var.contributors, local.governance_committee_team_id)

  # Check if sig-security-maintainers is explicitly specified in any permission list
  sig_security_in_admins       = contains(var.admins,       local.sig_security_maintainers_team_id)
  sig_security_in_maintainers  = contains(var.maintainers,  local.sig_security_maintainers_team_id)
  sig_security_in_approvers    = contains(var.approvers,    local.sig_security_maintainers_team_id)
  sig_security_in_triagers     = contains(var.triagers,     local.sig_security_maintainers_team_id)
  sig_security_in_contributors = contains(var.contributors, local.sig_security_maintainers_team_id)

  # Only add default permissions if the team is not explicitly specified elsewhere
  add_default_governance_committee = !(
    local.governance_committee_in_admins ||
    local.governance_committee_in_maintainers ||
    local.governance_committee_in_approvers ||
    local.governance_committee_in_triagers ||
    local.governance_committee_in_contributors
  )

  add_default_sig_security = !(
    local.sig_security_in_admins ||
    local.sig_security_in_maintainers ||
    local.sig_security_in_approvers ||
    local.sig_security_in_triagers ||
    local.sig_security_in_contributors
  )
}

resource "github_repository_collaborators" "this" {
  repository = var.repository

  # Admin teams
  dynamic "team" {
    for_each = var.admins
    content {
      team_id    = team.value
      permission = "admin"
    }
  }

  # Maintainer teams
  dynamic "team" {
    for_each = var.maintainers
    content {
      team_id    = team.value
      permission = "maintain"
    }
  }

  # Approver teams (push permission)
  dynamic "team" {
    for_each = var.approvers
    content {
      team_id    = team.value
      permission = "push"
    }
  }

  # Triager teams (triage permission)
  dynamic "team" {
    for_each = var.triagers
    content {
      team_id    = team.value
      permission = "triage"
    }
  }

  # Contributor teams (pull/read permission)
  dynamic "team" {
    for_each = var.contributors
    content {
      team_id    = team.value
      permission = "pull"
    }
  }

  # Individual users with specific permissions
  dynamic "user" {
    for_each = var.users
    content {
      username   = user.value.username
      permission = user.value.permission
    }
  }

  # Default governance-committee permission (only if not explicitly specified elsewhere)
  dynamic "team" {
    for_each = local.add_default_governance_committee ? [1] : []
    content {
      team_id = local.governance_committee_team_id
      permission = "push"
    }
  }

  # Default sig-security-maintainers permission (only if not explicitly specified elsewhere)
  dynamic "team" {
    for_each = local.add_default_sig_security ? [1] : []
    content {
      team_id = local.sig_security_maintainers_team_id
      permission = "pull"
    }
  }
}
