# =================================================================================================
# VARIABELS
# =================================================================================================
variable container_name {
  description = "Container name"
  type        = string
  default     = "aiqu/container-image-ansible"
}

variable container_registry_user {
  description = "Container registry username (for pushing image(s))"
  type        = string
  default     = ""
}

variable container_registry_token {
  description = "Container registry secret (for pushing image(s))"
  type        = string
  default     = ""
}

variable container_registry_url {
  description = "Container registry URL (for pushing image(s). Defaults to https://hub.docker.com/)"
  type        = string
  default     = ""
}
