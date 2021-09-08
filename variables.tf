variable "appname" {
  description = "Name of the Application to be onboarded"
}

variable "enviroments" {
  description = "list of enviroments"
  default     = ["prod", "dev"]
}

variable approle_path {
  type        = string
  default     = "approle"
  description = "The path of AppRole auth backend, eg, approle"
}

variable enable_approle {
  type        = bool
  default     = true
  description = "If approle roles should be enabled for the application"
}

