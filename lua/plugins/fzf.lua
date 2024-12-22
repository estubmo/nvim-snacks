return {
		"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	config = function()
		-- calling `setup` is optional for customization
		require("fzf-lua").setup({})
		local wk = require("which-key")
		wk.add({
			{ "<leader>f", group = "Find" }, -- group
			{ "<leader>ff", "<cmd>lua require('fzf-lua').files()<cr>", desc = "Find [f]ile" },
			{ "<leader>fg", "<cmd>lua require('fzf-lua').grep()<cr>", desc = "Find [g]rep" },
			{ "<leader><leader>", "<cmd>lua require('fzf-lua').buffers()<cr>", desc = "Find [b]uffers" },
		})
	end,
}
