ARG base_image=ubuntu:latest

FROM ${base_image}

ARG ansible_full=false

RUN set -e \
  && apt-get update \
  && apt-get -qqy install --no-install-recommends \
    python3-simplejson \
    python3-pip \
  && apt-get autoclean \
  && python3 -m pip install paramiko \
  && python3 -m pip install ansible-core \
  && ansible localhost -m ansible.builtin.debug -a msg="Provisioning finished!"

WORKDIR /opt/ansible

COPY ["./docker-entrypoint.sh","/usr/local/bin/docker-entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["ansible","--version"]