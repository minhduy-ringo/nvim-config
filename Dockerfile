# Docker file for base Neovim image

ARG ALPINE_VERSION="latest"
ARG NVIM_VERSION="stable"

# --- Stage 1: Build Neovim and plugins ---
FROM alpine:${ALPINE_VERSION} AS neovim-build

ARG NVIM_VERSION

# Update repositories and install build packages
RUN apk update && \
    apk add --no-cache "cmake>3.16" "gcc>4.9" build-base coreutils curl gettext-tiny-dev ninja-build git

# Build Neovim from source
WORKDIR /tmp
RUN git clone --depth 1 --branch ${NVIM_VERSION} https://github.com/neovim/neovim .
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install

# Set ENV variables for the user within this stage
ENV USER="nvimuser"
ENV HOME="/home/${USER}"
ENV XDG_CONFIG_HOME="${HOME}/.config"
ENV XDG_DATA_HOME="${HOME}/.local/share"

RUN adduser -D -h ${HOME} ${USER} && \
    mkdir -p ${XDG_CONFIG_HOME}/nvim \
	     ${XDG_DATA_HOME}/nvim && \
    chown -R ${USER}:${USER} ${HOME}

USER ${USER}
ADD "https://api.github.com/repos/minhduy-ringo/nvim-config/commits?per_page=1" latest_commit
RUN git clone --depth 1 https://github.com/minhduy-ringo/nvim-config.git ${XDG_CONFIG_HOME}/nvim

# Build plugins
RUN /usr/local/bin/nvim --headless "+Lazy! sync" "+TSUpdateSync" "+qa" || true{HOME}

# Stage 2: Set up runtime env
FROM alpine:${ALPINE_VERSION} AS neovim

# Set image locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

# Install needed packages for Neovim
RUN apk update && \
    apk add --no-cache libstdc++ git fzf curl wget ripgrep nodejs npm unzip python3 lazygit

ENV USER="nvimuser"
ENV HOME="/home/${USER}"
ENV XDG_CONFIG_HOME="${HOME}/.config"
ENV XDG_DATA_HOME="${HOME}/.local/share"
ENV XDG_CACHE_HOME="${HOME}/.cache"

# Create the user and their XDG directories in the final image
RUN adduser -D -h ${HOME} ${USER} && \
    mkdir -p ${XDG_CONFIG_HOME}/nvim \
             ${XDG_DATA_HOME}/nvim \
             ${XDG_CACHE_HOME}/nvim && \
    chown -R ${USER}:${USER} ${HOME}

COPY --from=neovim-build /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=neovim-build /usr/local/share/nvim /usr/local/share/nvim
COPY --from=neovim-build ${XDG_DATA_HOME}/nvim ${XDG_DATA_HOME}/nvim
COPY --from=neovim-build ${XDG_CONFIG_HOME}/nvim ${XDG_CONFIG_HOME}/nvim

USER ${USER}
ENV PATH="/usr/local/bin:$PATH"
ENV TERM=xterm-256color

CMD ["nvim"]
