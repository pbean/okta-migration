terraform {
  required_providers {
    okta = {
      source = "okta/okta"
      configuration_aliases = [ okta.preview, okta.production ]
    }
  }
}

# Get all user schema properties from the preview tenant
data "okta_user_schema" "all_properties" {
  provider = okta.preview
}

# Filter out the default properties
locals {
  custom_properties = {
    for prop in data.okta_user_schema.all_properties.properties : prop.index => prop
    if !contains(["firstName", "lastName", "email", "login", "secondEmail", "mobilePhone"], prop.index)
  }
}

# Check if the custom properties already exist in the production tenant
data "okta_user_schema_property" "existing_properties" {
  provider = okta.production
  for_each = local.custom_properties
  index    = each.value.index
}

# Create the custom properties in the production tenant if they don't already exist
resource "okta_user_schema_property" "imported_properties" {
  provider    = okta.production
  for_each    = { for k, v in local.custom_properties : k => v if data.okta_user_schema_property.existing_properties[k].id == null }
  index       = each.value.index
  title       = each.value.title
  type        = each.value.type
  description = each.value.description
  required    = each.value.required
  min_length  = each.value.min_length
  max_length  = each.value.max_length
  permissions = each.value.permissions
  enum        = each.value.enum
}
