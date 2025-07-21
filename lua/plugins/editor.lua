return {
  -- Bufferline
  -- This provide a tab-like UI look for buffer
  {
    'akinsho/bufferline.nvim',
    version = '*',
    depedencies = { 'nvim-tree/nvim-web-devicons', 'catppuccin' },
    config = function ()
      require('bufferline').setup {
	highlights = require('catppuccin.groups.integrations.bufferline').get {
	  themable = true,
	  separator_style = 'slope'
	},
      }
    end
  },

  -- Dashboard
  -- Provide a dashboard page when start Neovim
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
	-- TODO: Custom my own dashboard
      }
    end,
    dependencies = 'nvim-tree/nvim-web-devicons'
  },

  -- Lua line
  -- Vim status line writen in Lua
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require('lualine').setup {
	options = {
	  theme = 'catppuccin',
	  hide = {
	    statusline = false,
	  },
	}
      }
    end,
  },
}
