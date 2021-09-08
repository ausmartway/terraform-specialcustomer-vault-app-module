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
