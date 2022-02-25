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

#RUN curl -L https://github.com/dolthub/dolt/releases/latest/download/install.sh | bash
# install dolt from source
RUN cd ~ && git clone https://github.com/dolthub/dolt && cd dolt/go && go install ./cmd/dolt

USER gitpod

RUN mkdir -p /home/gitpod/.bashrc.d

COPY ./.gitpod/gitpod.bashrc /home/gitpod/.bashrc.d/99-gitpod-bashrc

