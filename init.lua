vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
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
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb', --GitHub
  -- Detect tabstop and shiftwidth automatically
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
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
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

  {
    "nvim-lua/plenary.nvim",
    {
      "ThePrimeagen/harpoon",
    },
    {
      "github/copilot.vim",
      event = "VeryLazy",
      autoStart = true,

    },
    {
      -- "zbirenbaum/copilot.lua",
      -- event = "VeryLazy",
      -- autoStart = true,
      -- opts = {
      --   suggestion = {
      --     keymap = {
      --       accept = "<Tab>",
      --       accept_word = "<S-Tab>",
      --       accept_line = false,
      --       next = "<C-.>",
      --       prev = "<C-,>",
      --       dismiss = "<C-/>",
      --     },
      --   },
      -- },
    },

  }
  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']c'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']C'] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[c'] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[C'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}



local function telescope_map(key, f, desc) 
  local fn = require('telescope.builtin')[f]
  vim.keymap.set('n', '<leader>f' .. key, fn, {desc = '[f]ind ' .. desc})
end

telescope_map('r', 'oldfiles', 'in [r]ecent buffers')
telescope_map('b', 'buffers', 'in [b]uffers')
telescope_map('g', 'git_files', '[g]it files')
telescope_map('f', 'find_files', '[f]iles')
telescope_map('w', 'grep_string', '[w]ord')
telescope_map('g', 'live_grep', 'by [g]rep')
telescope_map('d', 'diagnostics', '[d]iagnostics')
telescope_map('h', 'help_tags', '[h]elp')
telescope_map('S', 'lsp_document_symbols', '[s]ymbols')
telescope_map('S', 'lsp_dynamic_workspace_symbols', 'workspace [S]ymbols')
telescope_map('o', 'oldfiles', '[o]ld files')

vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] fuzzy find in current buffer' })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end
-- normal maps
nmap('<leader>w', ':w<CR>', '[w]rite file')
nmap('<leader>q', ':q<CR>', '[q]uit file')
nmap('<leader>x', ':wqa<CR>', 'e[x]it nvim')
nmap('<leader>n', ':enew<CR>', '[n]ew buffer')

nmap('<leader>o', ':Ex<CR>', '[o]pen tree')

vim.keymap.set({ 'n', 'v' }, 'L', '$', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'H', '^', { silent = true })

vim.keymap.set({ 'n', 'v' }, 'Y', 'y$')
vim.keymap.set('v', 'p', '"_dp')

-- [[ Configure LSP ]]

nmap('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename')
nmap('<leader>la', vim.lsp.buf.code_action, '[L]sp code [A]ction')
nmap('<leader>lf', vim.lsp.buf.format, '[L]sp [f]ormat')

nmap('gd', vim.lsp.buf.definition, '[g]oto [d]efinition')
nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
nmap('gI', vim.lsp.buf.implementation, '[g]oto [i]mplementation')
nmap('gtd', vim.lsp.buf.type_definition, '[g]oto [t]ype [d]efinition')

-- See `:help K` for why this keymap
nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

-- Lesser used LSP functionality
nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')

nmap('<leader>Wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [a]dd Folder')
nmap('<leader>Wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
nmap('<leader>Wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, '[W]orkspace [l]ist Folders')


-- [[ Harpoon ]]

local function harpoon_map(l, r, desc)
  local fn = require('telescope.builtin')[f]
  vim.keymap.set('n', l, r, { desc = desc, buffer = bufnr })
end

local harpoon = require("harpoon.ui")
harpoon_map('<Leader>ha', require("harpoon.mark").add_file, "[h]arpoon [a]dd file")
harpoon_map('<Leader>hm', harpoon.toggle_quick_menu, "[h]arpoon [m]enu")
harpoon_map('<Leader>hj', harpoon.nav_prev, "[h]arpoon go to previous")
harpoon_map('<Leader>hk', harpoon.nav_next, "[h]arpoon go to next")
harpoon_map('<leader>1', function() harpoon.nav_file(1) end, "harpoon go to 1")
harpoon_map('<leader>2', function() harpoon.nav_file(2) end, "harpoon go to 2")
harpoon_map('<leader>3', function() harpoon.nav_file(3) end, "harpoon go to 3")
harpoon_map('<leader>4', function() harpoon.nav_file(4) end, "harpoon go to 4")
harpoon_map('<leader>5', function() harpoon.nav_file(5) end, "harpoon go to 5")
harpoon_map('<leader>6', function() harpoon.nav_file(6) end, "harpoon go to 6")
harpoon_map('<leader>7', function() harpoon.nav_file(7) end, "harpoon go to 7")
harpoon_map('<leader>8', function() harpoon.nav_file(8) end, "harpoon go to 8")
harpoon_map('<leader>9', function() harpoon.nav_file(9) end, "harpoon go to 9")

--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  rust_analyzer = { },
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
