FROM gitpod/workspace-full

USER root

RUN export DEBIAN_FRONTEND='noninteractive' \
    && apt-get update \
    && apt-get install -y \
        netcat \
        build-essential \
        gettext \
        fzf \
        sshfs \
        tldr \
    && rm -rf /var/lib/apt/lists/*

USER gitpod

RUN mkdir -p /home/gitpod/.bashrc.d

COPY ./.gitpod/gitpod.bashrc /home/gitpod/.bashrc.d/99-gitpod-bashrc

