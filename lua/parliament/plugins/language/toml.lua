local lsp = require('funsak.lsp')

return {
  lsp.server("taplo", {
    server = {
      settings = {
        evenBetterToml = {
          schema = {
            associations = {}
          }
        }
      }
    }
  }),
  { "cespare/vim-toml", ft = { "toml", "markdown" } },
}
