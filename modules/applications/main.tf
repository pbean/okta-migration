terraform {
  required_providers {
    okta = {
      source = "oktadeveloper/okta"
      configuration_aliases = [ okta.preview, okta.production ]
    }
  }
}

# Read all applications from the preview tenant
data "okta_apps" "all_apps" {
  provider = okta.preview
}

# Filter out the applications to exclude
locals {
  apps_to_migrate = {
    for app in data.okta_apps.all_apps.apps : app.id => app
    if !contains(var.exclude_apps, app.label)
  }
}

# Check if the applications already exist in the production tenant
data "okta_app" "existing_apps" {
  provider = okta.production
  for_each = locals.apps_to_migrate
  label    = each.value.label
  active   = true
  skip_users = true
  skip_groups = true
}

# Create the applications in the production tenant if they don't already exist
resource "okta_app_auto_login" "imported_apps" {
  provider     = okta.production
  for_each     = { for k, v in local.apps_to_migrate : k => v if data.okta_app.existing_apps[k].id == null }
  label        = each.value.label
  sign_on_mode = each.value.sign_on_mode
  status       = each.value.status
}