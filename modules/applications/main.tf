terraform {
  required_providers {
    okta = {
      source                = "okta/okta"
      configuration_aliases = [okta.preview, okta.production]
    }
  }
}

# 1. Get all applications from the preview tenant
data "okta_apps" "preview_apps" {
  provider = okta.preview
}

# 2. Get all applications from the production tenant to check for existence
data "okta_apps" "production_apps" {
  provider = okta.production
}

locals {
  # Create a set of labels that already exist in production for easy lookup
  production_app_labels = toset([for app in data.okta_apps.production_apps.apps : app.label])

  # Filter the preview apps: remove explicitly excluded apps and apps that already exist in production
  apps_to_migrate = {
    for app in data.okta_apps.preview_apps.apps : app.id => app
    if !contains(var.exclude_apps, app.label) && !contains(local.production_app_labels, app.label)
  }

  # Create a list of apps that will be skipped
  skipped_apps = [ 
    for app in data.okta_apps.preview_apps.apps
    if contains(local.production_app_labels, app.label)
  ]
}

# 3. Create the applications in the production tenant if they don't already exist
resource "okta_app_auto_login" "imported_apps" {
  provider     = okta.production
  for_each     = local.apps_to_migrate
  label        = each.value.label
  sign_on_mode = each.value.sign_on_mode
  status       = each.value.status
}
