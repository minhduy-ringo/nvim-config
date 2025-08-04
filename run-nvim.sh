#!/bin/bash
set -e
# Set environment variables
FAKE_HOME="/fakehome"

export HOME="$FAKE_HOME"
export XDG_CONFIG_HOME="$FAKE_HOME/.config"
export XDG_DATA_HOME="$FAKE_HOME/.local/share"
export XDG_STATE_HOME="$FAKE_HOME/.local/state"
export XDG_CACHE_HOME="$FAKE_HOME/.cache"

mkdir -p $XDG_CONFIG_HOME/nvim $XDG_DATA_HOME/nvim $XDG_STATE_HOME/nvim $XDG_CACHE_HOME
if [ ! -f "$XDG_CONFIG_HOME/nvim/init.lua" ]; then
  echo "Copying default Neovim config to $XDG_CONFIG_HOME/nvim" 
  cp -r /opt/nvim-config/* "$FAKE_HOME/.config/nvim"
  cp -r /opt/nvim-data/* "$FAKE_HOME/.local/share/nvim"
  cp -r /opt/nvim-state/* "$FAKE_HOME/.local/state/nvim"
fi

exec nvim "$@"
