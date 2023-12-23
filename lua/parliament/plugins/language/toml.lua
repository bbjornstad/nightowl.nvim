local lz = require('funsak.lazy')

return {
  lz.lspsrv("taplo", {
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
