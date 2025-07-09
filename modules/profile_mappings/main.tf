terraform {
  required_providers {
    okta = {
      source = "oktadeveloper/okta"
      configuration_aliases = [ okta.preview, okta.production ]
    }
  }
}

# Get the user profile mapping source from the preview tenant
data "okta_profile_mapping_source" "source" {
  provider = okta.preview
}

# Create the user profile mapping in the production tenant
resource "okta_profile_mapping" "imported_mappings" {
  provider      = okta.production
  source_id     = data.okta_profile_mapping_source.source.id
  target_id     = data.okta_profile_mapping_source.source.target_id
  source_type   = data.okta_profile_mapping_source.source.source_type
  target_type   = data.okta_profile_mapping_source.source.target_type
  mappings      = data.okta_profile_mapping_source.source.mappings
}