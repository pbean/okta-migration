terraform {
  required_providers {
    okta = {
      source                = "okta/okta"
      configuration_aliases = [okta.preview, okta.production]
    }
  }
}

# 1. Find the applications in the preview tenant
data "okta_app" "preview_apps" {
  provider = okta.preview
  for_each = toset(var.app_labels)
  label    = each.key
}

# 2. Find the corresponding applications in the production tenant
data "okta_app" "production_apps" {
  provider = okta.production
  for_each = toset(var.app_labels)
  label    = each.key
}

# 3. Get the sign-on policy for each app in the preview tenant
data "okta_app_signon_policy" "preview_policies" {
  provider = okta.preview
  for_each = { for k, v in data.okta_app.preview_apps : k => v if v != null }
  app_id   = each.value.id
}

# 4. Create a new, dedicated sign-on policy for each app in the production tenant
resource "okta_app_signon_policy" "imported_policies" {
  provider    = okta.production
  for_each    = { for k, v in data.okta_app.production_apps : k => v if v != null && data.okta_app_signon_policy.preview_policies[k] != null }
  app_id      = each.value.id
  name        = "oktapreview-${data.okta_app_signon_policy.preview_policies[each.key].name}"
  description = data.okta_app_signon_policy.preview_policies[each.key].description
}
