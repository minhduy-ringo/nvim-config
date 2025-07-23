return {
  -- Bufferline
  -- This provide a tab-like UI look for buffer
  {
    'akinsho/bufferline.nvim',
    version = '*',
    depedencies = { 'nvim-tree/nvim-web-devicons', 'catppuccin' },
    config = function ()
      require('bufferline').setup {
	highlights = require('catppuccin.groups.integrations.bufferline').get(),
	options = {
	  themable = true,
	  separator_style = 'slope',
	},
      }
    end
  },

  -- Dashboard
  -- Provide a dashboard page when start Neovim
	--  {
	--    'nvimdev/dashboard-nvim',
	--    event = 'VimEnter',
	--    dependencies = 'nvim-tree/nvim-web-devicons',
	--    config = function()
	--      require('dashboard').setup {
	-- -- TODO: Custom my own dashboard
	-- theme = 'hyper',
	-- config = {
	--   week_header = {
	--     enable = true
	--   },
	--   shortcut = {
	--     { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
	--   },
	-- },
	--      }
	--    end,
	--  },

  -- Lua line
  -- Vim status line writen in Lua
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    dependencies = 'nvim-tree/nvim-web-devicons',
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

  -- Neo tree
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      'folke/snacks.nvim'
    },
    lazy = false,
    ---@module 'neo-tree'
    ---@type neotree.Config?
    opts = {
      -- NOTE: Add options here
      close_if_last_window = true, -- Usually this mean exit Neovim, so just close it
    },
    keys = {
      { '<leader>er', '<cmd>Neotree<CR>', desc = 'Explorer current' },
      { '<leader>ed', function() 
	  vim.ui.input(
	    { prompt = 'Root dir to open Neotree' },
	    function(path)
	      local f = io.open(path, "r")
	      if f then 
		vim.cmd('Neotree' .. input)
	      else
		local snacks_notify = require('snacks.notify')
		snacks_notify.error('Path not exist')
	      end
	    end
	  )
	end, desc = "Explorer dir"
      },
      { '<leader>et', '<cmd>Neotree toggle<CR>', desc = 'Explorer toggle' }
    }
  },
}
