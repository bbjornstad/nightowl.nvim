local lsp = require("funsak.lsp")
local colorizer = require("funsak.colors").dvalue

return {
  {
    "pwntester/codeql.nvim",
    cmd = { "QL" },
    opts = {},
    config = function(_, opts)
      require("codeql").setup(opts)
    end,
    ft = { "codeql_panel", "codeql_explorer" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        version = "v2.*",
        opts = {
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            bo = {
              filetype = {
                "codeql_panel",
                "codeql_explorer",
                "qf",
                "TelescopePrompt",
                "TelescopeResults",
                "notify",
                "noice",
                "NvimTree",
                "neo-tree",
              },
              buftype = { "terminal" },
            },
          },
          current_win_hl_color = colorizer("NormalFloat", "bg", { bg = "fg" }),
          other_win_hl_color = colorizer("NvimContainer", "fg"),
        },
        config = function(_, opts)
          require("window-picker").setup(opts)
        end,
      },
    },
  },
  lsp.server("codeqlls", { server = {} }),
}
