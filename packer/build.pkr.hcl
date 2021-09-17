# =================================================================================================
# REUSABLE VARIABLES
# =================================================================================================

locals {
  container_name           = var.container_name
  container_registry_url   = var.container_registry_url
  container_registry_token = var.container_registry_token
  container_registry_user  = var.container_registry_user
}

# =================================================================================================
# SOURCE IMAGES
# =================================================================================================

source docker "UBUNTU" {
  image   = "ubuntu:impish"
  commit  = true
  changes = ["ENTRYPOINT [\"/usr/bin/bash\"]"]
}

source docker "DEBIAN" {
  image   = "debian:bullseye-slim"
  commit  = true
  changes = ["ENTRYPOINT [\"/bin/bash\"]"]
}

source docker "ARCH" {
  image   = "archlinux:latest"
  commit  = true
  changes = ["ENTRYPOINT [\"/usr/sbin/bash\"]"]
}

source docker "ALPINE" {
  image   = "alpine:latest"
  commit  = true
  changes = ["ENTRYPOINT [\"/bin/ash\"]"]

}

source docker "ROCKY" {
  image   = "rockylinux/rockylinux:latest"
  commit  = true
  changes = ["ENTRYPOINT [\"/usr/bin/bash\"]"]
}

# =================================================================================================
# BUILD IMAGES
# =================================================================================================

build {
  sources = [
    "source.docker.UBUNTU",
    "source.docker.DEBIAN",
    "source.docker.ARCH",
    "source.docker.ALPINE",
    "source.docker.ROCKY",
  ]

  # -------------------------------------------------------------------------------------------------
  # PROVISIONING - Install OS packages
  # -------------------------------------------------------------------------------------------------

  # DEBIAN
  provisioner "shell" {
    only = [
      "docker.UBUNTU",
      "docker.DEBIAN",
    ]

    inline = [
      <<-PROVISIONING
      echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
      apt-get update
      apt-get -qqy install --no-install-recommends apt-utils > /dev/null 2>&1 
      apt-get -qqy install --no-install-recommends python3-simplejson python3-pip
      apt-get autoclean
      python3 -m pip install paramiko ansible-core
      PROVISIONING
    ]
  }

  # REDHAT
  provisioner "shell" {
    only = [
      "docker.ROCKY",
    ]

    inline = [
      <<-PROVISIONING
      dnf --quiet --assumeyes install python39
      python3 -m pip install -U pip wheel
      python3 -m pip install -U paramiko ansible-core
      dnf clean all
      PROVISIONING
    ]
  }

  # APK
  provisioner "shell" {
    only = [
      "docker.ALPINE",
    ]

    inline = [
      <<-PROVISIONING
      apk add --no-cache python3 py3-pip py3-cryptography py3-yaml py3-paramiko py3-lxml
      python3 -m pip install -U pip wheel
      python3 -m pip install -U ansible-core
      PROVISIONING
    ]
  }

  # PACMAN
  provisioner "shell" {
    only = [
      "docker.ARCH",
    ]

    #inline_shebang = "/usr/sbin/bash -e"
    inline = [
      <<-PROVISIONING
      pacman -Sy --sysupgrade --quiet --noconfirm
      pacman -S  --quiet --noconfirm python-pip
      pacman -S  --clean --quiet --noconfirm
      python -m pip install -U pip wheel
      python -m pip install -U ansible-core
      PROVISIONING
    ]
  }

  # -------------------------------------------------------------------------------------------------
  # PROVISIONING - Add Ansible collections
  # -------------------------------------------------------------------------------------------------

  # Adds ~12MB
  provisioner "shell" {
    #only = ["NaN"]
    inline = [
      "ansible-galaxy collection install community.general",
    ]
  }

  # -------------------------------------------------------------------------------------------------
  # PROVISIONING - Upload file(s)
  # -------------------------------------------------------------------------------------------------

  provisioner "file" {
    only        = ["NaN"]
    direction   = "upload"
    source      = "./context/docker-entrypoint.sh"
    destination = "/usr/local/bin/docker-entrypoint.sh"
  }

  # Using python venv
  provisioner "file" {
    only        = ["NaN"]
    direction   = "upload"
    source      = "./context/docker-entrypoint.venv.sh"
    destination = "/usr/local/bin/docker-entrypoint.sh"
  }

  # -------------------------------------------------------------------------------------------------
  # POST-PROCESSORS - Tag containers
  # -------------------------------------------------------------------------------------------------

  post-processors {
    post-processor "docker-tag" {
      repository = local.container_name
      tags = [
        "${lower(source.name)}",
        "${lower(source.name)}-${formatdate("YYYYMMDD", timestamp())}",
        "${lower(source.name)}-latest",
      ]
    }

    # Tag only a selected 'primary' image as 'latest'
    post-processor "docker-tag" {
      only       = ["docker.DEBIAN"]
      repository = local.target_image
      tags       = ["latest"]
    }

    # Push images
    post-processor "docker-push" {
      name = "push"

      login_username = local.container_registry_user
      login_password = local.container_registry_token
      login_server   = local.container_registry_url
    }
  }
}

# =================================================================================================
# END
# =================================================================================================
