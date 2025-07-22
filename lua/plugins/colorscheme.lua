return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    riority = 1000,
    config = function()
      require('catppuccin').setup {
	transparent_background = false,
	integrations = {
	  dashboard = true,		  -- Highlight for dashboard.nvim
	  snacks = {			  -- Snacks scope indent 
	    enabled = true,
	    indent_scope_color = 'flamingo',
	  }
	}
      }
      -- Load the theme
      vim.cmd([[colorscheme catppuccin]])
    end,
  }
}
