vim.keymap.set('n',' x', ':x')
vim.keymap.set('n',' w', ':w')
vim.keymap.set('n',' q', ':q')



vim.api.nvim_command('command! resource luafile $MYVIMRC')
vim.api.nvim_command('command! config e $MYVIMRC')
