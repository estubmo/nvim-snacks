local function biome_or_prettier()
	local has_biome = vim.fs.find({
		"biome.json",
	}, { upward = true })[1]
	if has_biome then
		return { "biome" }
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
				javascript = biome_or_prettier,
				typescript = biome_or_prettier,
				javascriptreact = biome_or_prettier,
				typescriptreact = biome_or_prettier,
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
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "biome", "vtsls" },
			})

			mason_lspconfig.setup_handlers(handlers)
		end,
		-- opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },

		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.vtsls.setup({})
			lspconfig.biome.setup({})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- Pre-configure linters
			local function get_linter_config()
				local has_biome = vim.fs.find({
					"biome.json",
				}, { upward = true })[1]

				if has_biome then
					return { "biome" }
				end

				local has_eslint = vim.fs.find({
					-- https://eslint.org/docs/latest/use/configure/configuration-files
					-- https://eslint.org/docs/latest/use/configure/configuration-files-deprecated
					".eslintrc.json",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					"eslint.config.ts ",
					"eslint.config.mts",
					"eslint.config.cts",
				}, { upward = true })[1]

				if has_eslint then
					return { "eslint_d" }
				end

				return { "biome" } -- default fallback
			end

			-- Set up initial linter configuration
			local active_linters = get_linter_config()
			lint.linters_by_ft = {
				javascript = active_linters,
				typescript = active_linters,
				javascriptreact = active_linters,
				typescriptreact = active_linters,
				json = { "jsonlint" },
				-- Use the "*" filetype to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
				-- ['_'] = { 'fallback linter' },
				-- ["*"] = { "typos" },
			}

			-- Create an autocmd group for lint
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			-- Create autocmd to trigger linting
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>ll", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
	{
		"rshkarin/mason-nvim-lint",
		config = function()
			local mason_nvim_lint = require("mason-nvim-lint")
			mason_nvim_lint.setup({
				ignore_install = { "vale", "tflint", "hadolint", "clj-kondo", "ruby", "inko", "janet" },
				ensure_installed = { "eslint_d", "biome", "jsonlint" },
			})
		end,
	},
}
