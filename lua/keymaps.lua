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

require('treesitter-cfg')

-- See `:help telescope.builtin`

local function get_desc(arg, desc)
  if desc then return desc else return arg end
end

local function tscope(key, f, desc)
  local fn = require('telescope.builtin')[f]
  vim.keymap.set('n', '<leader>f' .. key, fn, { desc = '[f]ind ' .. get_desc(arg, desc) })
end

local function tscope_drop(key, f, desc)
  vim.keymap.set('n', '<leader>f' .. key, function()
    require('telescope.builtin')[f](
      require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      }
    )
  end, { desc = '[f]ind ' .. get_desc(arg, desc) })
end

tscope_drop('/', 'current_buffer_fuzzy_find', '[/] fuzzy find in current buffer')
tscope('g', 'git_files', '[g]it files')
tscope('f', 'find_files', '[f]iles')
tscope('w', 'grep_string', '[w]ord')
tscope('g', 'live_grep', 'by [g]rep')
tscope('d', 'diagnostics', '[d]iagnostics')
tscope('h', 'help_tags', '[h]elp')
tscope('o', 'oldfiles', '[o]ld files')
tscope('b', 'builtin', '[b]uiltin')

-- command_history
-- commands
-- git_bcommits
-- git_branches
-- git_commits
-- git_files
-- git_stash
-- git_status
-- grep_string
-- help_tags
-- highlights
-- jumplist
-- keymaps
-- live_grep
-- loclist
-- man_pages
-- marks
-- oldfiles
-- quickfix
-- quickfixhistory
-- registers
-- reloader
-- resume
-- search_history
-- spell_suggest
-- symbols
-- tags
-- tagstack
-- treesitter
-- vim_options


-- [regular maps]

local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

nmap('<leader>w', ':w<CR>', '[w]rite file')
nmap('<leader>q', ':q<CR>', '[q]uit file')
nmap('<leader>x', ':wqa<CR>', 'e[x]it nvim')
nmap('<leader>n', ':enew<CR>', '[n]ew buffer')

nmap('<leader>o', ':Ex<CR>', '[o]pen tree')
vim.keymap.set('c', '<C-v>', '<C-r>+')


vim.keymap.set({ 'n', 'v' }, 'L', '$', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'H', '^', { silent = true })

vim.keymap.set({ 'n', 'v' }, 'Y', 'y$')
vim.keymap.set('v', 'p', '"_dP')

vim.api.nvim_command('command! Resource luafile $MYVIMRC')
vim.api.nvim_command('command! Config e $MYVIMRC')


-- [[ Configure LSP ]]
local function tscope_lsp(key, f, desc)
  local fn = require('telescope.builtin')[f]
  vim.keymap.set('n', 'g' .. key, fn, { desc = '[G]o to ' .. get_desc(f, desc) })
end

nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
nmap('<leader>r', vim.lsp.buf.rename, '[R]ename')
nmap('<leader>a', vim.lsp.buf.code_action, '[L]sp code [A]ction')
nmap('<leader>lf', vim.lsp.buf.format, '[L]sp [f]ormat')
nmap('<leader>lh', vim.lsp.buf.document_highlight, '[L]sp [h]ighlight')
nmap('<leader>lH', vim.lsp.buf.clear_references, '[L]sp [h]ighlight')
nmap('<leader>lr', ':LspRestart<CR>', '[L]sp [r]eload')
tscope_lsp('d', "lsp_definitions", '[d]efinition')
tscope_lsp('i', "lsp_implementations", '[i]mplementation')
tscope_lsp('t', "lsp_type_definitions", '[t]ype [d]efinition')
tscope_lsp('r', "lsp_references", '[r]eferences')
tscope_lsp('z', "lsp_incoming_calls")
tscope_lsp('Z', "lsp_outgoing_calls")
tscope_lsp('s', "lsp_document_symbols")
tscope_lsp('S', "lsp_workspace_symbols")

-- [[ Harpoon ]]
local harpoon = require("harpoon.ui")
nmap('<Leader>ha', require("harpoon.mark").add_file, "[h]arpoon [a]dd file")
nmap('<Leader>hm', harpoon.toggle_quick_menu, "[h]arpoon [m]enu")
nmap('<Leader>hj', harpoon.nav_prev, "[h]arpoon go to previous")
nmap('<Leader>hk', harpoon.nav_next, "[h]arpoon go to next")
nmap('<leader>1', function() harpoon.nav_file(1) end, "harpoon go to 1")
nmap('<leader>2', function() harpoon.nav_file(2) end, "harpoon go to 2")
nmap('<leader>3', function() harpoon.nav_file(3) end, "harpoon go to 3")
nmap('<leader>4', function() harpoon.nav_file(4) end, "harpoon go to 4")
nmap('<leader>5', function() harpoon.nav_file(5) end, "harpoon go to 5")
nmap('<leader>6', function() harpoon.nav_file(6) end, "harpoon go to 6")
nmap('<leader>7', function() harpoon.nav_file(7) end, "harpoon go to 7")
nmap('<leader>8', function() harpoon.nav_file(8) end, "harpoon go to 8")
nmap('<leader>9', function() harpoon.nav_file(9) end, "harpoon go to 9")
