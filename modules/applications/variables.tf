variable "exclude_apps" {
  description = "A list of application labels to exclude from the migration."
  type        = list(string)
  default     = []
}
