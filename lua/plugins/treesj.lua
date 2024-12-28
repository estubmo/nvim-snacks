return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
	config = function()
		require("treesj").setup({})
		vim.keymap.set("n", "<Leader>tj", "<Cmd>TSJJoin<CR>", { desc = "" })
		vim.keymap.set("n", "<Leader>ts", "<Cmd>TSJSplit<CR>", { desc = "" })
	end,
}
