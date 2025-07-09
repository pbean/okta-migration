output "skipped_applications" {
  description = "A list of application labels that were skipped because they already exist in the production tenant."
  value       = local.skipped_apps
}
