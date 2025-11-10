return {
  -- Bufferline
  -- This provide a tab-like UI look for buffer
  {
    'akinsho/bufferline.nvim',
    version = '*',
    depedencies = { 'nvim-tree/nvim-web-devicons', 'catppuccin' },
  },

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
	},
	sections = {
	  lualine_x = { 'vim.fn.getcwd()', 'filetype' }
	}
      }
    end,
  },
}
