# Docker file for base Neovim image

ARG ALPINE_VERSION="latest"
ARG NVIM_VERSION="stable"

# --- Stage 1: Build Neovim and plugins ---
FROM alpine:${ALPINE_VERSION} AS neovim-build

ARG NVIM_VERSION

# Update repositories and install build packages
RUN apk update && \
    apk add --no-cache "cmake>3.16" "gcc>4.9" build-base coreutils pkgconfig libtool autoconf automake curl gettext-tiny-dev samurai git

# Build Neovim from source
WORKDIR /tmp
RUN git clone --depth 1 --branch ${NVIM_VERSION} https://github.com/neovim/neovim .
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install

# --- Stage 2: Build Neovim plugins ---
FROM neovim-build AS plugins-build

# Set ENV variables for the user within this stage
ENV USER="nvimuser"
ENV HOME="/home/${USER}"
ENV XDG_CONFIG_HOME="${HOME}/.config"
ENV XDG_DATA_HOME="${HOME}/.local/share"
ENV XDG_STATE_HOME="${HOME}/.local/state"

RUN adduser -D -h ${HOME} ${USER} && \
    mkdir -p ${XDG_CONFIG_HOME}/nvim \
	     ${XDG_STATE_HOME}/nvim \
	     ${XDG_DATA_HOME}/nvim && \
    chown -R ${USER}:${USER} ${HOME}

ARG LOCAL_CONFIG

USER ${USER}
COPY --chown=${USER}:${USER} . ${XDG_CONFIG_HOME}/nvim  

# Build plugins
RUN /usr/local/bin/nvim --headless "+Lazy! sync" "+TSUpdateSync" "+qa"

# Copy compile plugins data to /tmp and set permissions
# this is need for the next stage
RUN cp -r $XDG_CONFIG_HOME/nvim /tmp/nvim-config && \
    cp -r $XDG_DATA_HOME/nvim /tmp/nvim-data && \
    cp -r $XDG_STATE_HOME/nvim /tmp/nvim-state && \
    chmod -R a+rwX /tmp/nvim-* && \
    chmod -R a+rx /tmp/nvim-config/run-nvim.sh

# Stage 3: Set up runtime env
FROM alpine:${ALPINE_VERSION} AS neovim

# Set image locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

# Install needed packages for Neovim
RUN apk update && \
    apk add --no-cache g++ libstdc++ git fzf curl wget ripgrep nodejs npm unzip python3 lazygit

# Set ENV variables for the user within this stage
COPY --from=plugins-build /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=plugins-build /usr/local/share/nvim /usr/local/share/nvim
COPY --from=plugins-build /tmp/nvim-config /opt/nvim-config
COPY --from=plugins-build /tmp/nvim-data /opt/nvim-data
COPY --from=plugins-build /tmp/nvim-state /opt/nvim-state

RUN mkdir -p /fakehome && chmod 0777 /fakehome

CMD ["sh", "/opt/nvim-config/run-nvim.sh"]
