-- quickly mark todo boxes as done or not done
vim.keymap.set('n', '<leader><space>', "^f[va]c[x]<esc>", {})
vim.keymap.set('n', '<leader><leader><space>', "^f[va]c[ ]<esc>", {})
