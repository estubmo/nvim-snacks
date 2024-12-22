local function biome_lsp_or_prettier(bufnr)
	local has_biome_lsp = vim.lsp.get_clients({
		bufnr = bufnr,
		name = "biome",
	})[1]
	if has_biome_lsp then
		return {}
	end
	local has_prettier = vim.fs.find({
		-- https://prettier.io/docs/en/configuration.html
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.js",
		".prettierrc.cjs",
		".prettierrc.toml",
		"prettier.config.js",
		"prettier.config.cjs",
	}, { upward = true })[1]
	if has_prettier then
		return { "prettier" }
	end
	return { "biome" }
end

local function biome_lsp_or_eslint(bufnr)
	local has_biome_lsp = vim.lsp.get_clients({
		bufnr = bufnr,
		name = "biome",
	})[1]
	if has_biome_lsp then
		return {}
	end
	local has_eslint = vim.fs.find({
		".eslintrc.json",
	}, { upward = true })[1]
	if has_eslint then
		return { "eslint_d" }
	end
	return { "biome" }
end

local handlers = {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({})
	end,
	["lua_ls"] = function()
		local lspconfig = require("lspconfig")
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
	end,
}

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>lf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		-- This will provide type hinting with LuaLS
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			formatters_by_ft = {
				javascript = biome_lsp_or_prettier,
				typescript = biome_lsp_or_prettier,
				javascriptreact = biome_lsp_or_prettier,
				typescriptreact = biome_lsp_or_prettier,
				json = { "biome" },
				jsonc = { "biome" },
				lua = { "stylua" },
			},
			format_on_save = true,
		},
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts = {
			ensure_installed = { "biome", "eslint_d", "prettier" },
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },

		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup()

			mason_lspconfig.setup_handlers(handlers)
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters_by_ft = {
				fish = { "fish" },

				javascript = biome_lsp_or_eslint,
				typescript = biome_lsp_or_eslint,
				javascriptreact = biome_lsp_or_eslint,
				typescriptreact = biome_lsp_or_eslint,
				json = { "biome" },
				jsonc = { "biome" },
				-- Use the "*" filetype to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
				-- ['_'] = { 'fallback linter' },
				-- ["*"] = { "typos" },
			},
		},
		config = function() end,
	},
	{
		"rshkarin/mason-nvim-lint",
		opts = {},
	},
}
