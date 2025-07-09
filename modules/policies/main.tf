terraform {
  required_providers {
    okta = {
      source = "oktadeveloper/okta"
      configuration_aliases = [ okta.preview, okta.production ]
    }
  }
}

# Read all policies from the preview tenant

data "okta_policy" "all_policies" {
  provider = okta.preview
  type     = "OKTA_SIGN_ON"
}

# Create the policies in the production tenant

resource "okta_policy_signon" "imported_policies" {
  provider    = okta.production
  for_each    = { for policy in data.okta_policy.all_policies.policies : policy.id => policy }
  name        = "oktapreview-${each.value.name}"
  status      = each.value.status
  description = each.value.description
}