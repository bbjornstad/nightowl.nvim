local lsp = require("funsak.lsp")

return {
  lsp.server("nushell", { server = {} }),
  {
    "LhKipp/nvim-nu",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    build = ":TSUpdateSync nu",
    ft = { "nu" },
    opts = {
      use_lsp_features = false,
      all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']],
    },
    config = function(_, opts)
      require("nu").setup(opts)

      vim.filetype.add({
        extension = {
          nu = "nu",
        },
        pattern = {
          ["*.nu"] = "nu",
          ["~/.config/nushell/core/*"] = "nu",
          ["~/.config/nushell/util/*"] = "nu",
          ["~/.config/nushell/completions/"] = "nu",
        },
      })
      vim.filetype.add({
        pattern = {
          [".*"] = {
            priority = -math.huge,
            function(path, bufnr)
              local content = vim.filetype.getlines(bufnr, 1)
              if vim.filetype.matchregex(content, [[^#!/usr/bin/env nu]]) then
                return "nu"
              end
            end,
          },
        },
      })
    end,
  },
  lsp.server("bashls", { server = {} }),
  lsp.formatters({ bash = { "shellharden", "shfmt", "beautysh" } }),
  lsp.formatters({ zsh = { "beautysh" } }),
  lsp.linters({ bash = { "shellcheck" } }),
}
