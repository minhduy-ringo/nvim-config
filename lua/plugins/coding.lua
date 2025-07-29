return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
	'L3MON4D3/LuaSnip',
	version = '2.*',
	build = (function()
	  -- Build Step is needed for regex support in snippets.
	  -- This step is not supported in many windows environments.
	  -- Remove the below condition to re-enable on windows.
	  if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
	    return
	  end
	  return 'make install_jsregexp'
	end)(),
	dependencies = {
	  -- `friendly-snippets` contains a variety of premade snippets.
	  --    See the README about individual language/framework/plugin snippets:
	  --    https://github.com/rafamadriz/friendly-snippets
	  {
	    'rafamadriz/friendly-snippets',
	    config = function()
	      require('luasnip.loaders.from_vscode').lazy_load()
	    end,
	  },
	},
	opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
	-- 'default' (recommended) for mappings similar to built-in completions
	--   <c-y> to accept ([y]es) the completion.
	--    This will auto-import if your LSP supports it.
	--    This will expand snippets if the LSP sent a snippet.
	-- 'super-tab' for tab to accept
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	-- All presets have the following mappings:
	-- <tab>/<s-tab>: move to right/left of your snippet expansion
	-- <c-space>: Open menu or open docs if already open
	-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
	-- <c-e>: Hide menu
	-- <c-k>: Toggle signature help
	--
	-- See :h blink-cmp-config-keymap for defining your own keymap
	preset = 'super-tab',
      },

      appearance = {
	nerd_font_variant = 'mono',
      },

      completion = {
	-- By default, you may press `<c-space>` to show the documentation.
	-- Optionally, set `auto_show = true` to show the documentation after a delay.
	documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
	default = { 'lsp', 'path', 'snippets', 'lazydev' },
	providers = {
	  lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
	},
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
