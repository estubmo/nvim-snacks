-- mason, write correct names only
vim.api.nvim_create_user_command("MasonInstallAll", function()
	vim.cmd(
		"MasonInstall lua-language-server vtsls biome tailwindcss-language-server emmet-language-server stylua prettierd"
	)
end, {})
