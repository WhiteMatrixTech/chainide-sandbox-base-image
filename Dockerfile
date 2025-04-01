FROM ubuntu:22.04

ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=chainide
ARG USER_UID=1000
ARG USER_GID=$USER_UID

COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
RUN yes | unminimize 2>&1 \
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# install node22 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    npm install -g corepack && \
    corepack enable && \
    corepack prepare yarn@stable --activate

RUN cp /root/.zshrc /tmp/.zshrc && \
    cp /root/.bashrc /tmp/.bashrc && \
    cp -r /root/.oh-my-zsh /tmp/.oh-my-zsh && \
    cp /root/.profile /tmp/.profile
