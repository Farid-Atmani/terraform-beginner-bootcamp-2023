variable "user_uuid" {
  description = "The UUID of the user."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message = "The user_uuid value is not a valid UUID."
  }
}

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"

  validation {
    condition     = (
      length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 && 
      can(regex("^[a-z0-9][a-z0-9-.]*[a-z0-9]$", var.bucket_name))
    )
    error_message = "Bucket name must be lowercase alphanumeric characters or hyphens, and must start and end with an alphanumeric character."
  }
}
