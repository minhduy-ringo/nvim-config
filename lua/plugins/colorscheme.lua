return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    riority = 1000,
    config = function()
      require('catppuccin').setup {
	transparent_background = false,
      }
      -- Load the theme
      vim.cmd([[colorscheme catppuccin]])
    end,
  }
}
