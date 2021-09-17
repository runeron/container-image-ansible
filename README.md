# CONTAINER-IMAGE-ANSIBLE
Ansible running in a container.

#### FEATURES
- python3 / pip
- ansible-core + community.general collection (~12M)

## USAGE
```bash
# Running container interactively
docker run --rm -it -v `pwd`/files:/files/:ro <image>:alpine

# Use ansible as normal from container
ansible --version
ansible-playbook --version
ansible localhost -m ping

# Run playbook "externally"
docker run --rm -it -v `pwd`/files:/files/:ro <image>:alpine -c "ansible-playbook files/playbook.debug.yml"

# usine alias
alias dansible='docker run --rm -it -v `pwd`/files:/files/:ro <image>:alpine -c'
dansible "ansible --version"
dansible "ansible-playbook files/playbook.debug.yml"
unalias dansible
```