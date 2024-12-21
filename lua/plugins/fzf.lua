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
			{ "<leader>ff", "<cmd>lua require('fzf-lua').files()<cr>", desc = "Find file" }, -- group
		})
	end,
}
