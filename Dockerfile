# Docker file for base Neovim image

ARG ALPINE_VERSION="latest"
ARG NVIM_VERSION="stable"

# --- Stage 1: Build Neovim and plugins ---
FROM alpine:${ALPINE_VERSION} AS neovim-build

ARG NVIM_VERSION

# Update repositories and install build packages
RUN apk update && \
    apk add --no-cache "cmake>3.16" "gcc>4.9" build-base coreutils pkgconfig libtool autoconf automake curl gettext-tiny-dev samurai git openjdk21 nodejs npm bash

# Build Neovim from source
WORKDIR /tmp
RUN git clone --depth 1 --branch ${NVIM_VERSION} https://github.com/neovim/neovim .
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install

# --- Stage 2: Build Neovim plugins ---
FROM neovim-build AS plugins-build

# Set ENV variables for the user within this stage
ENV XDG_CONFIG_HOME="/root/.config"
ENV XDG_DATA_HOME="/root/.local/share"
ENV XDG_STATE_HOME="/root/.local/state"

RUN mkdir -p ${XDG_CONFIG_HOME}/nvim \
	     ${XDG_STATE_HOME}/nvim \
	     ${XDG_DATA_HOME}/nvim \
	     ${XDG_CACHE_HOME}/nvim

COPY . ${XDG_CONFIG_HOME}/nvim

# Build plugins
RUN nvim --headless "+Lazy! sync" "+TSUpdateSync" "+MasonToolsInstallSync" "+qa"

# Stage 3: Set up runtime env
FROM alpine:${ALPINE_VERSION} AS neovim

# Set image locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=tmux-256color

ENV XDG_CONFIG_HOME="/opt/.config"
ENV XDG_DATA_HOME="/opt/.local/share"
ENV XDG_STATE_HOME="/opt/.local/state"
ENV XDG_CACHE_HOME="/opt/.cache"

# Install needed packages for Neovim
RUN apk update && \
    apk add --no-cache g++ libstdc++ bash git fzf curl wget ripgrep unzip lazygit

# Create a default neovim user for this image
RUN addgroup -S neovim && adduser -S -G neovim neovimuser

# Set ENV variables for the user within this stage
COPY --from=plugins-build --chown=neovimuser:neovim /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=plugins-build --chown=neovimuser:neovim /usr/local/share/nvim /usr/local/share/nvim
COPY --from=plugins-build --chown=neovimuser:neovim /root/.config/ ${XDG_CONFIG_HOME}
COPY --from=plugins-build --chown=neovimuser:neovim /root/.local/share ${XDG_DATA_HOME}
COPY --from=plugins-build --chown=neovimuser:neovim /root/.local/state ${XDG_STATE_HOME}
COPY --from=plugins-build --chown=neovimuser:neovim /root/.cache ${XDG_CACHE_HOME}

RUN chmod -R 777 /opt
USER neovimuser
