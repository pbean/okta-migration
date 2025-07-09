terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.10"
    }
  }
}

provider "okta" {
  org_name  = var.okta_org_name_preview
  base_url  = var.okta_base_url_preview
  api_token = var.okta_api_token_preview
  alias     = "preview"
}

provider "okta" {
  org_name  = var.okta_org_name_production
  base_url  = var.okta_base_url_production
  api_token = var.okta_api_token_production
  alias     = "production"
}

# To migrate resources, uncomment the module blocks below.
# You will need to implement the logic to read the resources from the preview tenant and create them in the production tenant.

module "applications" {
  source       = "./modules/applications"
  exclude_apps = ["Okta Browser Plugin", "Okta Dashboard"]
}


module "policies" {
  source = "./modules/policies"
}

# module "workflows" {
#   source = "./modules/workflows"
# }

# module "profile_sources" {
#   source = "./modules/profile_sources"
# }

# module "configurations" {
#   source = "./modules/configurations"
# }