terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 5.1.0"
    }
  }
}

provider "okta" {
  alias     = "preview"
  org_name  = var.okta_org_name_preview
  base_url  = var.okta_base_url_preview
  api_token = var.okta_api_token_preview
}

provider "okta" {
  alias     = "production"
  org_name  = var.okta_org_name_production
  base_url  = var.okta_base_url_production
  api_token = var.okta_api_token_production
}

# To migrate resources, uncomment the module blocks below.
# You will need to implement the logic to read the resources from the preview tenant and create them in the production tenant.

module "applications" {
  source       = "./modules/applications"
  providers = {
    okta.preview    = okta.preview
    okta.production = okta.production
  }
  exclude_apps = ["Okta Browser Plugin", "Okta Dashboard"]
}

module "policies" {
  source = "./modules/policies"
  providers = {
    okta.preview    = okta.preview
    okta.production = okta.production
  }
  signon_policy_names           = ["Default Policy"]
  password_policy_names         = ["Default Policy"]
  mfa_policy_names              = ["Default Policy"]
}

module "app_signon_policy" {
  source    = "./modules/app_signon_policy"
  providers = {
    okta.preview    = okta.preview
    okta.production = okta.production
  }
  app_labels = ["My App 1", "My App 2"]
}

# Only enable and use if needed, not really a practical application for migration but for IaaC
#module "user_schema" {
#  source    = "./modules/user_schema"
#  providers = {
#    okta.production = okta.production
#  }
#  custom_properties = [
#    {
#      index       = "customAttribute1"
#      title       = "Custom Attribute 1"
#      type        = "string"
#      description = "This is a custom attribute."
#      required    = false
#      permissions = "READ_WRITE"
#      master      = "OKTA"
#      enum        = []
#      unique      = "NOT_UNIQUE"
#    }
#  ]
#}

## TODO: When possible
#module "workflows" {
#  source = "./modules/workflows"
#}

#module "profile_sources" {
#  source = "./modules/profile_sources"
#}

# module "configurations" {
#   source = "./modules/configurations"
# }