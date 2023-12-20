return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", {
        taplo = {
          evenBetterToml = {
            schema = {
              associations = {},
            },
          },
        },
      }, opts.servers or {})
    end,
  },
  { "cespare/vim-toml", ft = { "toml", "markdown" } },
}
