local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("i", "jk", "<ESC>")
map("i", "jj", "<ESC>") -- TODO: Exchange for betterjj
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

map("n", "gD", function()
	vim.lsp.buf.declaration()
end, { desc = "Declaration of current symbol" })
map("n", "gd", function()
	vim.lsp.buf.definition()
end, { desc = "Definition of current symbol" })
