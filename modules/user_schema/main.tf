resource "okta_user_schema_property" "custom_properties" {
  provider    = okta.production
  for_each    = { for prop in var.custom_properties : prop.index => prop }

  index       = each.value.index
  title       = each.value.title
  type        = each.value.type
  description = each.value.description
  required    = each.value.required
  permissions = each.value.permissions
  master      = each.value.master
  enum        = each.value.enum
  unique      = each.value.unique
}
