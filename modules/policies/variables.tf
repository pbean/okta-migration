variable "signon_policies" {
  description = "A map of Okta Sign-On Policies to create."
  type = map(object({
    description = string
    groups_included = list(string)
  }))
  default = {}
}

variable "password_policies" {
  description = "A map of Password Policies to create."
  type = map(object({
    description                       = string
    priority                          = number
    password_min_length               = number
    password_min_lowercase            = number
    password_min_number               = number
    password_min_symbol               = number
    password_min_uppercase            = number
    password_max_age_days             = number
    password_expire_warn_days         = number
    password_history_count            = number
    password_max_lockout_attempts     = number
    password_auto_unlock_minutes      = number
    password_show_lockout_failures    = bool
    password_lockout_notification_channels = list(string)
  }))
  default = {}
}

variable "mfa_policies" {
  description = "A map of MFA Policies to create."
  type = map(object({
    description    = string
    authenticators = list(string)
  }))
  default = {}
}