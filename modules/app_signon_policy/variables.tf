variable "app_labels" {
  description = "A list of application labels for which to migrate app-specific sign-on policies."
  type        = list(string)
  default     = []
}
