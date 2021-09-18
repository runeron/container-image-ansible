.DEFAULT_GOAL := validate

# =================================================================================================
# CUSTOMIZE BUILD
# =================================================================================================
target_image ?= local/ansible

# =================================================================================================
# DEFINE PACKER VARIABLES
# =================================================================================================
export PKR_VAR_container_name           := ${target_image}
export PKR_VAR_container_registry_url   := registry.hub.docker.com
#export PKR_VAR_container_registry_url   := 
#export PKR_VAR_container_registry_token := 
#export PKR_VAR_container_registry_user  := 

# =================================================================================================
# DEFINE PACKER GOALS
# =================================================================================================
PHONY: info fmt validate init build push

info:
	@echo IMAGE: ${PKR_VAR_container_name}
	@echo REGISTRY: ${PKR_VAR_container_registry_url}

fmt:
	@packer fmt -check ./packer/

validate:
	@packer validate --syntax-only ./packer/

init:
	@packer init ./packer/

build:
	@packer build -except=push -color=false -on-error=abort -only=*.ALPINE ./packer/

push:
	@packer build -only=*.ALPINE -color=true -on-error=abort ./packer/
