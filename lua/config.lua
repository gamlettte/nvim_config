vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd ('colorscheme midnight')
vim.cmd ('set list')
--vim.cmd ('set listchars=multispace:.\ \ \ ')
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.foldmethod="expr"
vim.opt.foldlevel=99
vim.opt.foldexpr="nvim_treesitter#foldexpr()"
vim.opt.list = true
vim.opt.listchars = { leadmultispace = '·   ', tab = '> ' }
vim.keymap.set('n', '<space>Q', ":cclose<CR>")
vim.keymap.set('n', '<space>q', ":copen<CR>")
vim.cmd('set completeopt-=preview')
