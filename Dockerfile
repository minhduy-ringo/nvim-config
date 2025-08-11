
# Docker file for base Neovim image

ARG DEBIAN_VERSION="bookworm-slim"
ARG NVIM_VERSION="stable"

# --- Stage 1: Build Neovim and plugins ---
FROM debian:${DEBIAN_VERSION} AS neovim-build

ARG NVIM_VERSION="stable"

# Update repositories and install build packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential cmake gcc coreutils pkg-config libtool autoconf automake curl git openjdk-17-jdk nodejs npm bash ninja-build unzip

# Build Neovim from source
WORKDIR /tmp/neovim
RUN git clone --depth 1 --branch ${NVIM_VERSION} https://github.com/neovim/neovim .
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install

# --- Stage 2: Neovim image ---
FROM neovim-build AS plugins-build

ARG HOST_UID=1000
ARG HOST_GID=1000

RUN groupadd -g ${HOST_GID} hostuser && useradd -m -u ${HOST_UID} -g ${HOST_GID} hostuser

USER hostuser
WORKDIR /home/hostuser

ENV XDG_CONFIG_HOME=/home/hostuser/.config
ENV XDG_DATA_HOME=/home/hostuser/.local/share
ENV XDG_STATE_HOME=/home/hostuser/.local/state

COPY --chown=hostuser:hostuser . ${XDG_CONFIG_HOME}/nvim

RUN nvim --headless "+Lazy! sync" "+TSUpdateSync" "+MasonToolsInstallSync" "+qa"

# --- Stage 3: Final image ---
FROM debian:${DEBIAN_VERSION}

ARG HOST_UID=1000
ARG HOST_GID=1000

# Install needed packages for Neovim
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-17-jdk python3 nodejs npm g++ bash git fzf curl wget ripgrep unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set image locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TERM=screen-256color

RUN groupadd -g ${HOST_GID} hostuser && useradd -m -u ${HOST_UID} -g ${HOST_GID} hostuser

ENV XDG_CONFIG_HOME=/home/hostuser/.config
ENV XDG_DATA_HOME=/home/hostuser/.local/share
ENV XDG_CACHE_HOME=/home/hostuser/.cache
ENV XDG_STATE_HOME=/home/hostuser/.local/state

COPY --from=plugins-build --chown=hostuser:hostuser /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=plugins-build --chown=hostuser:hostuser /usr/local/share/nvim /usr/local/share/nvim
COPY --from=plugins-build /home/hostuser/.config/nvim /home/hostuser/.config/nvim
COPY --from=plugins-build /home/hostuser/.local /home/hostuser/.local

CMD ["nvim"]
