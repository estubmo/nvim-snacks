local map = vim.keymap.set

-- general mappings
map("n", "<C-s>", "<cmd> w <CR>")
map("i", "jk", "<ESC>")
map("i", "jj", "<ESC>") -- TODO: Exchange for betterjj
map("n", "<C-c>", "<cmd> %y+ <CR>") -- copy whole filecontent

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

-- alternate file switching
map("n", "<Tab>", "<C-^>", { desc = "Switch to alternate file" })
map("n", "<BS>", "<cmd>vsplit #<CR>", { desc = "Open alternate file in split" })

-- -- Add this to your statusline configuration
-- -- If you're using lualine, add this component:
-- local function alternate_file()
--     local alt_file = vim.fn.expand('#:t')
--     if alt_file == '' then
--         return ''
--     end
--     return '⟺ ' .. alt_file
-- end
--
-- -- Example lualine config (adjust according to your setup):
-- require('lualine').setup({
--     sections = {
--         lualine_x = {
--             alternate_file,
--             -- your other components...
--         }
--     }
-- })
-- LSP mappings
map("n", "gD", function()
	vim.lsp.buf.declaration()
end, { desc = "Declaration of current symbol" })
map("n", "gd", function()
	vim.lsp.buf.definition()
end, { desc = "Definition of current symbol" })
