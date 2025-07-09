
# This is a placeholder for reading workflows from the preview tenant.
# You will need to implement the logic to read the workflows from the preview tenant and create them in the production tenant.
# The following is an example of how you might structure the code.

# data "okta_workflows" "all_workflows" {
#   provider = okta.preview
# }

# resource "okta_workflow" "imported_workflows" {
#   provider = okta.production
#   for_each = { for workflow in data.okta_workflows.all_workflows.workflows : workflow.id => workflow }
#   name     = each.value.name
#   status   = each.value.status
# }
