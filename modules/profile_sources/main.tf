# This module migrates user profile mapping sources from the preview tenant to the production tenant.
# NOTE: This implementation iterates through all users to find profile mappings, which can be inefficient for a large number of users.

data "okta_users" "all_users" {
  provider = okta.preview
}

# For each user, get the profile mapping source
data "okta_user_profile_mapping_source" "mapping_sources" {
  provider  = okta.preview
  for_each  = { for user in data.okta_users.all_users.users : user.id => user }
  user_id   = each.value.id
}

# Create the profile mapping sources in the production tenant
resource "okta_user_profile_mapping_source" "imported_mapping_sources" {
  provider  = okta.production
  for_each  = { for key, mapping in data.okta_user_profile_mapping_source.mapping_sources : key => mapping if mapping != null }
  user_id   = each.key
  # The following attributes are just examples. You will need to adjust them to match your needs.
  # type      = each.value.type
  # name      = each.value.name
}