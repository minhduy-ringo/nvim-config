-- Key mapping
-- Check plugins/Snacks.lua for more <leader> keys map

local map = function(lhs, rhs, opts, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Esc to espace mode
map('<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
-- map('<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- map('<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- map('<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- map('<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('<S-h>', '<cmd>bprevious<CR>', { desc = 'Move to previous buffer' })
map('<S-l>', '<cmd>bnext<CR>', { desc = 'Move to next buffer' })

-- Resize window using <ctrl> arrow keys
map('<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map('<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map('<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map('<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Disable 's' key, this affect the mini.surround plugin
map('s', '<Nop>', { desc = '' }, {'n', 'x'})
map('S', '<Nop>', { desc = '' }, {'n', 'x'})

-- Windows
map('<leader>wc', '<C-w>q', { desc = 'Close focus window' })
map('<leader>wh', '<C-w>s', { desc = 'Split window horizontally' })
map('<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
