variable "region" {
  type        = string
  description = "(optional) describe your variable"
}

variable "function_name" {
  type        = string
  description = "A unique name for your Lambda Function."
}

variable "handler" {
  type        = string
  description = "The function entrypoint in your code."
}

variable "runtime" {
  type        = string
  description = "See Runtimes for valid values."
}

variable "variables" {
  type        = map(string)
  description = "A map that defines environment variables for the Lambda function."
}

variable "iam_role_name" {
  type        = string
  description = "IAM role attached to the Lambda Function."
}

#ecr image
variable "package_type" {
  type        = string
  description = "(optional) describe your variable"
}

variable "image_uri" {
  type        = string
  description = "(optional) describe your variable"
}

/*

#zip file = filename & source_code_hash
variable "filename" {
    type = string
    description = "The path to the function's deployment package within the local filesystem."
    default = "genie_api.zip"
}

variable "source_code_hash" {
  default     = null
  description = "Used to trigger updates when file contents change.  Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key."
  type        = string
}


variable "timeout" {
  type        = number
  default     = 3
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
}

*/
