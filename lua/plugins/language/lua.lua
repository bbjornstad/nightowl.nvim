local masonry = require("uutils.lazy").masonry

return {
  masonry({ name = "lua_ls", lang = "lua" }, function()
    return require("lsp-zero").nvim_lua_ls({
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          }
        }
      }
    })
  end, { "VonHeikemen/lsp-zero.nvim" }),
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   dependencies = { "neovim/nvim-lspconfig" },
  --   opts = function(_, opts)
  --     opts = vim.tbl_deep_extend("force", opts, {
  --       handlers = {
  --         lua_ls = function()
  --           local zero = require("lsp-zero")
  --           require("lspconfig").lua_ls.setup(zero.nvim_lua_ls({}))
  --         end,
  --       },
  --     })
  --   end,
  -- },
}
