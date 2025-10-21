-- NOTE: Basic Autocommands
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto read buffer edit
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  desc = 'Auto detect Jenkins file as groovy',
  group = vim.api.nvim_create_augroup('jenkins-groovy', { clear = true }),
  pattern = "*Jenkinsfile*",
  callback = function()
    vim.cmd('set filetype=groovy')
  end,
})

