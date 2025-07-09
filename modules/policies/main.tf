terraform {
  required_providers {
    okta = {
      source                = "okta/okta"
      configuration_aliases = [okta.preview, okta.production]
    }
  }
}

# --- Sign On Policies ---

data "okta_policy_signon" "signon_source" {
  for_each = toset(var.signon_policy_names)
  provider = okta.preview
  name     = each.value
}

resource "okta_policy_signon" "imported_signon" {
  for_each    = { for k, v in data.okta_policy_signon.signon_source : k => v if v.status == "ACTIVE" }
  provider    = okta.production
  name        = "oktapreview-${each.value.name}"
  status      = "INACTIVE"
  description = each.value.description
}

data "okta_policy_password" "password_source" {
  for_each = toset(var.password_policy_names)
  provider = okta.preview
  name     = each.value
}

resource "okta_policy_password" "imported_password" {
  for_each                               = { for k, v in data.okta_policy_password.password_source : k => v if v.status == "ACTIVE" }
  provider                               = okta.production
  name                                   = "oktapreview-${each.value.name}"
  status                                 = "INACTIVE"
  description                            = each.value.description
  priority                               = each.value.priority
  password_min_length                    = each.value.min_length
  password_min_lowercase                 = each.value.min_lowercase
  password_min_number                    = each.value.min_number
  password_min_symbol                    = each.value.min_symbol
  password_min_uppercase                 = each.value.min_uppercase
  password_max_age_days                  = each.value.max_age_days
  password_expire_warn_days              = each.value.expire_warn_days
  password_history_count                 = each.value.history_count
  password_max_lockout_attempts          = each.value.max_lockout_attempts
  password_auto_unlock_minutes           = each.value.auto_unlock_minutes
  password_show_lockout_failures         = each.value.show_lockout_failures
  password_lockout_notification_channels = each.value.lockout_notification_channels
}

data "okta_policy_mfa" "mfa_source" {
  for_each = toset(var.mfa_policy_names)
  provider = okta.preview
  name     = each.value
}

resource "okta_policy_mfa" "imported_mfa" {
  for_each       = { for k, v in data.okta_policy_mfa.mfa_source : k => v if v.status == "ACTIVE" }
  provider       = okta.production
  name           = "oktapreview-${each.value.name}"
  status         = "INACTIVE"
  description    = each.value.description
  authenticators = each.value.authenticators
}