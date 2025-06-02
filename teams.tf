resource "github_team" "test-maintainers" {
  name        = "test-approvers"
  parent_team_id = github_team.test-maintainers.id
  description = ""
  privacy     = "closed"
}

resource "github_team" "test-approvers" {
  name        = "test-approvers"
  parent_team_id = github_team.test-triagers.id
  description = ""
  privacy     = "closed"
}

resource "github_team" "test-triagers" {
  name        = "test-triagers"
  description = ""
  privacy     = "closed"
}
