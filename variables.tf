
# Okta Provider Configuration

# To set the API tokens as environment variables, run the following commands in your terminal:
# export TF_VAR_okta_api_token_preview="your_preview_api_token"
# export TF_VAR_okta_api_token_production="your_production_api_token"

variable "okta_api_token_preview" {
  description = "Okta API token for the preview tenant."
  type        = string
  sensitive   = true
}

variable "okta_api_token_production" {
  description = "Okta API token for the production tenant."
  type        = string
  sensitive   = true
}

variable "okta_org_name_preview" {
  description = "Okta organization name for the preview tenant."
  type        = string
  default     = "CHANGEME"
}

variable "okta_base_url_preview" {
  description = "Okta base URL for the preview tenant."
  type        = string
  default     = "oktapreview.com"
}

variable "okta_org_name_production" {
  description = "Okta organization name for the production tenant."
  type        = string
  default     = "CHANGEME"
}

variable "okta_base_url_production" {
  description = "Okta base URL for the production tenant."
  type        = string
  default     = "okta.com"
}
