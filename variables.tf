variable "appname" {
  description = "Name of the Application to be onboarded"
}

variable "enviroments" {
  description = "list of enviroments"
  default     = ["prod", "dev"]
}