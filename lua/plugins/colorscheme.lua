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
            vim.cmd("colorscheme catppuccin")
        end,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
        end,
    },
    {
        "EdenEast/nightfox.nvim",
        name = "nightfox",
    }
}
