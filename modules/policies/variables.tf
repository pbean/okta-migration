variable "signon_policy_names" {
  description = "A list of Okta Sign-On Policy names to migrate."
  type        = list(string)
  default     = []
}

variable "password_policy_names" {
  description = "A list of Password Policy names to migrate."
  type        = list(string)
  default     = []
}

variable "mfa_policy_names" {
  description = "A list of MFA Policy names to migrate."
  type        = list(string)
  default     = []
}



