resource "github_team" "java-approvers" {
  name        = "java-approvers"
  parent_team_id = github_team.java-triagers.id
  description = "hello"
  privacy     = "closed"
}

resource "github_team" "java-maintainers" {
  name        = "java-maintainers"
  parent_team_id = github_team.java-approvers.id
  description = ""
  privacy     = "closed"
}

resource "github_team" "java-triagers" {
  name        = "java-triagers"
  description = ""
  privacy     = "closed"
}

