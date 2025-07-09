terraform {
  required_providers {
    okta = {
      source                = "okta/okta"
      configuration_aliases = [okta.preview, okta.production]
    }
  }
}

# Get all user schema properties from the preview tenant
data "okta_user_schema" "preview_schema" {
  provider = okta.preview
}

# Get all user schema properties from the production tenant
data "okta_user_schema" "production_schema" {
  provider = okta.production
}

locals {
  # A set of the default property indexes to ignore
  default_property_indexes = toset([
    "firstName",
    "lastName",
    "email",
    "login",
    "secondEmail",
    "mobilePhone"
  ])

  # A set of property indexes that already exist in the production tenant
  production_property_indexes = toset([
    for prop in data.okta_user_schema.production_schema.properties : prop.index
  ])

  # The final map of properties to create.
  # We filter out default properties and properties that already exist in production.
  properties_to_create = {
    for prop in data.okta_user_schema.preview_schema.properties : prop.index => prop
    if !contains(local.default_property_indexes, prop.index) && !contains(local.production_property_indexes, prop.index)
  }
}

# Create the custom properties in the production tenant if they don't already exist
resource "okta_user_schema_property" "imported_properties" {
  provider    = okta.production
  for_each    = local.properties_to_create
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