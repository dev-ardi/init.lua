vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require("plugins")
require("plug-config")
require("options")
require("keymaps")
require("lsp")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
