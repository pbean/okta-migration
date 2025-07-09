terraform {
  required_providers {
    okta = {
      source                = "okta/okta"
      configuration_aliases = [okta.preview, okta.production]
    }
  }
}

# --- Sign On Policies ---

data "okta_policy" "signon_source" {
  provider = okta.preview
  for_each = toset(var.signon_policy_names)
  name     = each.key
}

resource "okta_policy_signon" "imported_signon" {
  provider    = okta.production
  for_each    = { for k, v in data.okta_policy.signon_source : k => v if v != null }
  name        = "oktapreview-${each.value.name}"
  status      = "INACTIVE"
  description = each.value.description
  priority    = each.value.priority
}

# --- Password Policies ---

data "okta_policy" "password_source" {
  provider = okta.preview
  for_each = toset(var.password_policy_names)
  name     = each.key
}

resource "okta_policy_password" "imported_password" {
  provider                          = okta.production
  for_each                          = { for k, v in data.okta_policy.password_source : k => v if v != null }
  name                              = "oktapreview-${each.value.name}"
  status                            = "INACTIVE"
  description                       = each.value.description
  priority                          = each.value.priority
  password_min_length               = each.value.password_min_length
  password_min_lowercase            = each.value.password_min_lowercase
  password_min_number               = each.value.password_min_number
  password_min_symbol               = each.value.password_min_symbol
  password_min_uppercase            = each.value.password_min_uppercase
  password_max_age_days             = each.value.password_max_age_days
  password_expire_warn_days         = each.value.password_expire_warn_days
  password_history_count            = each.value.password_history_count
  password_max_lockout_attempts     = each.value.password_max_lockout_attempts
  password_auto_unlock_minutes      = each.value.password_auto_unlock_minutes
  password_show_lockout_failures    = each.value.password_show_lockout_failures
  password_lockout_notification_channels = each.value.password_lockout_notification_channels
}

# --- MFA Policies ---

data "okta_policy" "mfa_source" {
  provider = okta.preview
  for_each = toset(var.mfa_policy_names)
  name     = each.key
}

resource "okta_policy_mfa" "imported_mfa" {
  provider      = okta.production
  for_each      = { for k, v in data.okta_policy.mfa_source : k => v if v != null }
  name          = "oktapreview-${each.value.name}"
  status        = "INACTIVE"
  description   = each.value.description
  priority      = each.value.priority
  okta_password = each.value.okta_password
  okta_otp      = each.value.okta_otp
  okta_question = each.value.okta_question
  okta_sms      = each.value.okta_sms
  okta_email    = each.value.okta_email
  okta_call     = each.value.okta_call
  okta_verify   = each.value.okta_verify
  fido_u2f      = each.value.fido_u2f
  fido_webauthn = each.value.fido_webauthn
  google_otp    = each.value.google_otp
  security_question = each.value.security_question
  symantec_vip  = each.value.symantec_vip
  duo           = each.value.duo
  yubikey_token = each.value.yubikey_token
  external_idp  = each.value.external_idp
}

# --- Authentication Policies ---

data "okta_policy" "authentication_source" {
  provider = okta.preview
  for_each = toset(var.authentication_policy_names)
  name     = each.key
}

resource "okta_policy_authentication" "imported_authentication" {
  provider    = okta.production
  for_each    = { for k, v in data.okta_policy.authentication_source : k => v if v != null }
  name        = "oktapreview-${each.value.name}"
  status      = "INACTIVE"
  description = each.value.description
  priority    = each.value.priority
}


