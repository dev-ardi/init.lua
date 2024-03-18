local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
vim.opt.rtp:prepend(lazypath)

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end

require('lazy').setup({

  'tpope/vim-fugitive',
  'tpope/vim-rhubarb', --GitHub
  'tpope/vim-sleuth',
  'tpope/vim-repeat',
  'tpope/vim-speeddating',

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    setup = {}
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

  "ii14/neorepl.nvim",
  -- 'andweeb/presence.nvim',

  "folke/neoconf.nvim",
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    -- config = function() require "lsp" end,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      'j-hui/fidget.nvim', --LSP progress

      -- Additional lua configuration, makes nvim stuff amazing!plug
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp'
      },

      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      -- 'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  {                     -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>l'] = { name = '[l]sp', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[f]ind', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = '[h]arpoon', _ = 'which_key_ignore' },
        ['<leader>G'] = { name = '[G]it', _ = 'which_key_ignore' },
        ['<leader>W'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      }
    end,
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  { 'numToStr/Comment.nvim',    opts = {} },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    opts =
    {
      setup = {
        pickers = {
          find_files = {
            hidden = true,
            file_ignore_patterns = { ".git/" },
          }
        }
      }
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
  },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- require 'plugs.rest',
  require 'plugs.gitsigns',
  require 'kickstart.plugins.debug',

  require 'kickstart.plugins.autoformat',

}, {
  ui = {
    -- If you have a Nerd Font, set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      -- cmd = '⌘',
      -- config = '🛠',
      -- event = '📅',
      -- ft = '📂',
      -- init = '⚙',
      -- keys = '🗝',
      -- plugin = '🔌',
      -- runtime = '💻',
      -- require = '🌙',
      -- source = '📄',
      -- start = '🚀',
      -- task = '📌',
      -- lazy = '💤 ',
    },
  },
})

require("plug-config")
