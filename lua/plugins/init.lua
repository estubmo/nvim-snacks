print("lua/plugins/init.lua")
return {

	{ lazy = true, "nvim-lua/plenary.nvim" },

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},

	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},

	{ "echasnovski/mini.icons", opts = {} },

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("plugins.configs.treesitter")
		end,
	},
}
