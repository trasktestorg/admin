variable "repository" {
  description = "The name of the repository"
  type        = string
}

variable "admins" {
  description = "List of team IDs that should have admin access"
  type        = list(string)
  default     = []
}

variable "maintainers" {
  description = "List of team IDs that should have maintain access"
  type        = list(string)
  default     = []
}

variable "approvers" {
  description = "List of team IDs that should have push access"
  type        = list(string)
  default     = []
}

variable "triagers" {
  description = "List of team IDs that should have triage access"
  type        = list(string)
  default     = []
}

variable "contributors" {
  description = "List of team IDs that should have pull access"
  type        = list(string)
  default     = []
}

variable "users" {
  description = "List of users with specific permissions"
  type = list(object({
    username   = string
    permission = string
  }))
  default = []
}
