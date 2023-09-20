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
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-speeddating',

  'andweeb/presence.nvim',


  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} }, --LSP progress

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local function map(mode, l, r, desc, opts)
          opts = opts or {}
          opts.buffer = bufnr
          opts.desc = desc
          vim.keymap.set(mode, l, r, opts)
        end

        local gs = package.loaded.gitsigns
        map('n', '<leader>GN', gs.prev_hunk, '[G]it go to Previous Hunk')
        map('n', '<leader>Gn', gs.next_hunk, '[G]it go to [N]ext Hunk')
        map('n', '<leader>Gh', gs.preview_hunk, '[G]it [p]review hunk')
        map('n', '<leader>Gsh', gs.stage_hunk, '[G]it [s]tage [h]unk')
        map('n', '<leader>Gsb', gs.stage_buffer, '[G]it [s]tage [b]uffer')
        map('n', '<leader>GSh', gs.undo_stage_hunk, '[G]it  un[S]tage [h]unk')
        map('n', '<leader>Gr', gs.reset_buffer, '[G]it [r]eset buffer')
        map('n', '<leader>Gb', function() gs.blame_line { full = true } end, '[G]it [b]lame')
        map('n', '<leader>GB', gs.toggle_current_line_blame, '[G]it [B]lame toggle')
        map('n', '<leader>Gd', gs.diffthis, '[G]it [d]iff')
        map('n', '<leader>Gdt', function() gs.diffthis('~') end, '[G]it [d]iff [t]his')
        map('n', '<leader>Gg', gs.toggle_deleted, '[G]it [g]one (toggle deleted)')
      end,
    },
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
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    opts = 
      {
        setup = {
         pickers = {
          find_files = {
            hidden=true,
            file_ignore_patterns = {".git/"},
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
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  "nvim-lua/plenary.nvim",
  "ThePrimeagen/harpoon",
  {
    "zbirenbaum/copilot.lua",
    event = "VeryLazy",
    autoStart = true,
    opts = {
      suggestion = {
        -- This is 
        keymap = {
          accept = "<C-M>",
          accept_word = "<C-S-M>",
          accept_line = false,
          next = "<C-.>",
          prev = "<C-,>",
          dismiss = "<C-/>",
          toggle = "<C-?>",
        },
      },
    },

  }

  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',
}, {})
