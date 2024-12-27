local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("i", "jk", "<ESC>")
map("i", "jj", "<ESC>") -- TODO: Exchange for betterjj
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-- move lines
map("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection up" })

map("n", "J", "mzJ`z", { desc = "Join lines" })
map("x", "<leader>p", '"_dP', { desc = "Paste and delete selection into void register" }) -- greatest remap ever

map("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

map(
	"n",
	"<leader>r",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace all occurences of word under cursor" }
)
-- buffer management
map("n", "<leader>]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bf", "<cmd>bfirst<CR>", { desc = "First buffer" })
map("n", "<leader>bl", "<cmd>blast<CR>", { desc = "Last buffer" })
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Close current window" })

-- LSP mappings
map("n", "gD", function()
	vim.lsp.buf.declaration()
end, { desc = "Declaration of current symbol" })
map("n", "gd", function()
	vim.lsp.buf.definition()
end, { desc = "Definition of current symbol" })
