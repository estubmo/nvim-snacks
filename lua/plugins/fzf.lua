return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({})
  end
}
