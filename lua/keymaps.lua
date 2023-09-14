-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Telescope. See `:help telescope` and `:help telescope.setup()` TODO
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
  ensure_installed =
    {
      'c',
      'cpp',
      'go',
      'lua',
      'python',
      'rust',
      'tsx',
      'typescript',
      'vimdoc',
      'vim',
      'json',
    },

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
-- regular maps
nmap('<leader>w', ':w<CR>', '[w]rite file')
nmap('<leader>q', ':q<CR>', '[q]uit file')
nmap('<leader>x', ':wqa<CR>', 'e[x]it nvim')
nmap('<leader>n', ':enew<CR>', '[n]ew buffer')

nmap('<leader>o', ':Ex<CR>', '[o]pen tree')
vim.keymap.set('c', '<C-v>', '<C-r>+')


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
nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
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
