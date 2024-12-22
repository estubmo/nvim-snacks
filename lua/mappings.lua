local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("i", "jk", "<ESC>")
map("i", "jj", "<ESC>") -- TODO: Exchange for betterjj
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent
