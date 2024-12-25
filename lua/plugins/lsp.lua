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
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },

		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.vtsls.setup({})
			lspconfig.biome.setup({})

			vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", { desc = "Go to references" })
			vim.keymap.set("n", "gy", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "Go to type definition" })
			vim.keymap.set("n", "<Leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document symbols" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
			vim.keymap.set("n", "<Leader>ld", function()
				vim.diagnostic.open_float(0, { scope = "line" })
			end, { desc = "Line diagnostics" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
			vim.keymap.set("n", "[e", function()
				vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
			end, { desc = "Previous error" })
			vim.keymap.set("n", "]e", function()
				vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
			end, { desc = "Next error" })
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
			-- maps.n["<Leader>la"] =
			--     { function() vim.lsp.buf.code_action() end, desc = "LSP code action", cond = "textDocument/codeAction" }
			--   maps.x["<Leader>la"] =
			--     { function() vim.lsp.buf.code_action() end, desc = "LSP code action", cond = "textDocument/codeAction" }
			--   maps.n["<Leader>lA"] = {
			--     function() vim.lsp.buf.code_action { context = { only = { "source" }, diagnostics = {} } } end,
			--     desc = "LSP source action",
			--     cond = "textDocument/codeAction",
			--   }
			vim.keymap.set({ "n", "v" }, "<Leader>la", function()
				require("fzf-lua").lsp_code_actions({
					winopts = {
						relative = "cursor",
						width = 0.6,
						height = 0.6,
						row = 1,
						preview = { vertical = "up:70%" },
					},
				})
			end, { desc = "LSP code action" })
			vim.keymap.set("n", "<Leader>lA", function()
				vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
			end, { desc = "LSP source action" })
			vim.keymap.set("n", "<Leader>ll", function()
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
