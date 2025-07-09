terraform {
  required_providers {
    okta = {
      source                = "okta/okta"
      configuration_aliases = [okta.preview, okta.production]
    }
  }
}

# --- Sign On Policies ---

# 1. Get list of sign on policies from the preview tenant
data "okta_policy" "signon_list" {
  provider = okta.preview
  type     = "OKTA_SIGN_ON"
}

# 2. Get full details for each sign on policy
data "okta_policy" "signon_details" {
  provider = okta.preview
  for_each = { for p in data.okta_policy.signon_list.policies : p.id => p }
  id       = each.value.id
}

# 3. Create the sign on policies in the production tenant
resource "okta_policy_signon" "imported_signon" {
  provider    = okta.production
  for_each    = data.okta_policy.signon_details
  name        = "oktapreview-${each.value.name}"
  status      = each.value.status
  description = each.value.description
  priority    = each.value.priority
}

# --- Password Policies ---

# 1. Get list of password policies from the preview tenant
data "okta_policy" "password_list" {
  provider = okta.preview
  type     = "PASSWORD"
}

# 2. Get full details for each password policy
data "okta_policy_password" "password_details" {
  provider  = okta.preview
  for_each  = { for p in data.okta_policy.password_list.policies : p.id => p }
  policy_id = each.value.id
}

# 3. Create the password policies in the production tenant
resource "okta_policy_password" "imported_password" {
  provider                          = okta.production
  for_each                          = data.okta_policy_password.password_details
  name                              = "oktapreview-${each.value.name}"
  status                            = each.value.status
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

# 1. Get list of MFA policies from the preview tenant
data "okta_policy" "mfa_list" {
  provider = okta.preview
  type     = "MFA_ENROLLMENT"
}

# 2. Get full details for each MFA policy
data "okta_policy_mfa" "mfa_details" {
  provider  = okta.preview
  for_each  = { for p in data.okta_policy.mfa_list.policies : p.id => p }
  policy_id = each.value.id
}

# 3. Create the MFA policies in the production tenant
resource "okta_policy_mfa" "imported_mfa" {
  provider      = okta.production
  for_each      = data.okta_policy_mfa.mfa_details
  name          = "oktapreview-${each.value.name}"
  status        = each.value.status
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
