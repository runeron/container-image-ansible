# CONTAINER-IMAGE-ANSIBLE
Ansible running in a container.

#### LINKS
  * [GitHub](https://github.com/runeron/container-image-ansible)
  * [DockerHub](https://hub.docker.com/r/aiqu/container-image-ansible)

#### FEATURES
  * python3 / pip
  * ansible-core
  * community.general collection (~12M)

## USAGE
```bash
# Download pre-build image
docker pull aiqu/container-image-ansible

# Running container interactively
docker run --rm -it -v `pwd`/files:/files/:ro aiqu/container-image-ansible

# Use ansible as normal from container
ansible --version
ansible-playbook --version
ansible localhost -m ping

# Run playbook "externally"
docker run --rm -it -v `pwd`/files:/files/:ro aiqu/container-image-ansible -c "ansible-playbook files/playbook.debug.yml"

# usine alias
alias dansible='docker run --rm -it -v `pwd`/files:/files/:ro aiqu/container-image-ansible -c'
dansible "ansible --version"
dansible "ansible-playbook files/playbook.debug.yml"
unalias dansible
```
