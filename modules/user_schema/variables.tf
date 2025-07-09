variable "custom_properties" {
  description = "A list of custom user schema properties to create."
  type = list(object({
    index       = string
    title       = string
    type        = string
    description = optional(string)
    required    = optional(bool, false)
    permissions = optional(string, "READ_WRITE")
    master      = optional(string, "OKTA")
    enum        = optional(list(string), [])
    unique      = optional(string, "NOT_UNIQUE")
  }))
  default = []
}
