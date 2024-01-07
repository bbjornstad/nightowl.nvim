local lsp = require("funsak.lsp")
local preq = require("funsak.masquerade").preq

return {
  lsp.server("lua_ls", {
    server = preq("lsp-zero").nvim_lua_ls({
      settings = {
        Lua = {
          codeLens = {
            enable = true,
          },
        },
      },
    }),
  }),
  lsp.server("efm", {
    server = function(_)
      local function cfg(_)
        local languages = require("efmls-configs.defaults").languages()
        return {
          filetypes = vim.tbl_keys(languages),
          settings = {
            languages = vim.tbl_extend("force", languages, {
              lua = {
                lsp.util.efmls({ "linters.selene", "formatters.stylua" }, {
                  rootMarkers = {
                    ".luarc.json",
                    ".luarc.jsonc",
                    ".luacheckrc",
                    ".stylua.toml",
                    "stylua.toml",
                    "selene.toml",
                    "selene.yml",
                    ".git",
                  },
                }),
              },
            }),
          },
        }
      end
      return cfg(_)
    end,
    dependencies = { "creativenull/efmls-configs-nvim" },
  }),
  lsp.linters({ lua = { "selene" } }),
  lsp.formatters({ lua = { "stylua" } }),
  {
    "folke/neoconf.nvim",
    opts = {
      plugins = {
        lua_ls = {
          enabled_for_neovim_config = true,
          enabled = true,
        },
      },
    },
  },
}
