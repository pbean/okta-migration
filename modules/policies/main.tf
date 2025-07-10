terraform {
  required_providers {
    okta = {
      source                = "okta/okta"
      configuration_aliases = [okta.preview, okta.production]
    }
  }
}

resource "okta_policy_signon" "imported_signon" {
  for_each    = var.signon_policies
  provider    = okta.production
  name        = "oktapreview-${each.key}"
  status      = "INACTIVE"
  description = each.value.description
  groups_included = each.value.groups_included
}

resource "okta_policy_password" "imported_password" {
  for_each                               = var.password_policies
  provider                               = okta.production
  name                                   = "oktapreview-${each.key}"
  status                                 = "INACTIVE"
  description                            = each.value.description
  priority                               = each.value.priority
  password_min_length                    = each.value.password_min_length
  password_min_lowercase                 = each.value.password_min_lowercase
  password_min_number                    = each.value.password_min_number
  password_min_symbol                    = each.value.password_min_symbol
  password_min_uppercase                 = each.value.password_min_uppercase
  password_max_age_days                  = each.value.password_max_age_days
  password_expire_warn_days              = each.value.password_expire_warn_days
  password_history_count                 = each.value.password_history_count
  password_max_lockout_attempts          = each.value.password_max_lockout_attempts
  password_auto_unlock_minutes           = each.value.password_auto_unlock_minutes
  password_show_lockout_failures         = each.value.password_show_lockout_failures
  password_lockout_notification_channels = each.value.password_lockout_notification_channels
}

resource "okta_policy_mfa" "imported_mfa" {
  for_each       = var.mfa_policies
  provider       = okta.production
  name           = "oktapreview-${each.key}"
  status         = "INACTIVE"
  description    = each.value.description
  authenticators = each.value.authenticators
}