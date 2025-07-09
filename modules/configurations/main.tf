
# This is a placeholder for reading configurations from the preview tenant.
# You will need to implement the logic to read the configurations from the preview tenant and create them in the production tenant.
# The following is an example of how you might structure the code.

# data "okta_configurations" "all_configurations" {
#   provider = okta.preview
# }

# resource "okta_configuration" "imported_configurations" {
#   provider = okta.production
#   for_each = { for configuration in data.okta_configurations.all_configurations.configurations : configuration.id => configuration }
#   name     = each.value.name
#   value    = each.value.value
# }
