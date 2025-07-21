return {
  {
    'folke/tokyonight.nvim',
    lazy = true,
    opts = { style = 'moon' }
  },
  {
    'scottmckendry/cyberdream.nvim',
    lazy = true,
    priotiry = 1000
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    riority = 1000,
    config = function()
      require('catppuccin').setup {
	transparent_background = false,
	integrations = {
	  dashboard = true
	}
      }
      -- Load the theme
      vim.cmd([[colorscheme catppuccin]])
    end,
  }
}
