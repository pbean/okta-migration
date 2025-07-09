
# Read all applications from the preview tenant

data "okta_apps" "all_apps" {
  provider = okta.preview
}

# Create the applications in the production tenant

resource "okta_app_auto_login" "imported_apps" {
  provider    = okta.production
  for_each    = { for app in data.okta_apps.all_apps.apps : app.id => app }
  label       = each.value.label
  sign_on_mode = each.value.sign_on_mode
  status      = each.value.status
}
