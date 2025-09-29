-- ====================
-- General Settings
-- ====================
-- Define a leader key, which serves as a prefix for keyboard shortcuts.
-- The space (' ') is a popular choice because it's easy to access.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<leader>t', '<cmd>botright vsplit | terminal<CR>', { desc = 'Open terminal on the right' })
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Open/close file tree' })

vim.cmd("tnoremap <C-t> <C-\\><C-n><C-w>p")
vim.cmd("nnoremap <C-t> <C-w>p")
vim.cmd("tnoremap <Esc> <C-\\><C-n>")

-- General Neovim options to improve the experience.
vim.opt.nu = true               -- Displays the absolute line number.
vim.opt.relativenumber = false  -- Displays line numbers relative to the cursor's position.
vim.opt.mouse = 'a'             -- Enables mouse usage in all modes.
vim.opt.expandtab = false       -- Uses spaces instead of tab characters. Essential for consistency.
vim.opt.tabstop = 4             -- Defines the visual size of a tab as 4 spaces.
vim.opt.shiftwidth = 4          -- Defines the amount of spaces to be used for indentation.
vim.opt.smartindent = true      -- Enables automatic indentation based on code context.
vim.opt.wrap = true             -- Prevents text lines from wrapping and continuing on the next line.
vim.opt.termguicolors = true    -- Enables true colors in the terminal. Essential for modern themes.

-- ====================
-- Plugin Management (lazy.nvim)
-- ====================
-- This section configures the `lazy.nvim` plugin manager.
-- It checks if the plugin is installed and clones it from GitHub if necessary.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 'lazy.setup' lists all the plugins that Neovim should manage.
require('lazy').setup({
  'neovim/nvim-lspconfig',      -- The main plugin for the Neovim LSP client.
  'hrsh7th/nvim-cmp',           -- The autocompletion engine.
  'hrsh7th/cmp-nvim-lsp',       -- Autocompletion suggestion source via LSP.
  'hrsh7th/cmp-buffer',         -- Autocompletion suggestion source based on the buffer content.
  'L3MON4D3/LuaSnip',           -- A snippets engine (pre-defined code blocks).
  'saadparwaiz1/cmp_luasnip',   -- Integrates the snippets engine with the autocompletion engine.
  'catppuccin/nvim',            -- The Catppuccin color theme.
  'rebelot/kanagawa.nvim',      -- The Kanagawa color theme.
  'nvim-tree/nvim-tree.lua',    -- File tree.
  'quarto-dev/quarto-nvim',     -- Quarto R.
  'jmbuhr/otter.nvim',          -- Quarto R dependency.
})

require('nvim-tree').setup({})

-- ====================
-- Theme Configuration
-- ====================
-- Configures and applies the Catppuccin theme.
require('catppuccin').setup({
  -- Choose one of the theme's "flavors": "latte" (light), "frappe", "macchiato", or "mocha" (dark).
  flavour = 'macchiato',
  transparent_background = false,
})

-- Configures and applies the Kanagawa theme.
require('kanagawa').setup({
  theme = "dragon", -- Choose the theme variant: "dragon", "wave" or "lotus".
  transparent = false,
  background = {
    dark = "wave",  -- Background style for dark mode.
    light = "lotus" -- Background style for light mode.
  },
})

-- The `colorscheme` command applies the chosen theme to Neovim.
vim.cmd.colorscheme 'kanagawa'

-- ====================
-- LSP and Autocompletion Configuration
-- ====================
-- Imports the necessary modules.
local cmp = require('cmp')

local lsps = {
  {
    "clangd", {
      init_options = {
        fallbackFlags = {
          '-std=c23', '-W', '-Wall', '-Wextra', '-Wformat=2',
          '--query-driver=' .. vim.fn.executable('clang'),
          '-resource-dir=' .. vim.fn.executable('clang') .. '/../lib/clang/<version>'
        },
        on_attach = function(_, bufnr)
          vim.diagnostics.show(bufnr)
        end,
      },
    }
  },
  { "gopls" }, { "rust-analyzer" }, { "zls" },
  { "jdtls" }, { "pyright" },
  {
    "haskell", {
      cmd = { "haskell-language-server-wrapper", "--lsp" },
    }
  },
}

for _, lsp in pairs(lsps) do
  local name, config = lsp[1], lsp[2]
  vim.lsp.enable(name)
  if config then
    vim.lsp.config(name, config)
  end
end

-- Configures nvim-cmp for autocompletion.
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').jump(args.body)
    end,
  },
  -- Key mapping for navigation in the autocompletion menu.
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  -- Defines the sources for autocompletion suggestions.
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
}) 

-- ====================
-- Diagnostic Settings
-- ====================
-- Configures the display of errors and warnings.
vim.diagnostic.config({
  -- Displays the full error text next to the code.
  virtual_text = true,
  -- Disables the diagnostic icons in the left column ('E', 'W').
  signs = false,
  -- Underlines the code with the error.
  underline = true,
  -- Updates diagnostics while you are in insert mode.
  update_in_insert = false,
})

-- ====================
-- Quarto Configuration
-- ====================
require('quarto').setup{
  debug = false,
  closePreviewOnExit = true,
  lspFeatures = {
    enabled = true,
    chunks = "curly",
    languages = { "r", "python", "bash", "html" },
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
    enabled = true,
    default_method = "slime", -- "molten", "slime", "iron" or <function>
    ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
    -- Takes precedence over `default_method`
    never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
  },
}
