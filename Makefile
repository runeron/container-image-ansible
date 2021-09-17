.DEFAULT_GOAL := validate

# =================================================================================================
# CUSTOMIZE BUILD
# =================================================================================================
target_image ?= local/ansible

# =================================================================================================
# DEFINE PACKER VARIABLES
# =================================================================================================
export PKR_VAR_container_name    := target_image
#PKR_VAR_container_registry_url   := 
#PKR_VAR_container_registry_token := 
#PKR_VAR_container_registry_user  := 

# =================================================================================================
# DEFINE PACKER GOALS
# =================================================================================================
PHONY: fmt validate init build push

fmt:
	@packer fmt -check ./packer/

validate:
	@packer validate --syntax-only ./packer/

init:
	@packer init ./packer/

build:
	@packer build -except=push -color=false -on-error=abort ./packer/

push:
	@packer build -color=false -on-error=abort ./packer/
