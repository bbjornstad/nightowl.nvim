local toggle_fmtoption = require("uutils.text").toggle_fmtopt
local deflang = require("funsak.lazy").language
local masonry = require('funsak.lazy').masonry

return {
  unpack(deflang({ "yaml", "yml" }, { "yamlfmt" }, { "yamllint" })),
  masonry({ name = "yamlls", lang = "yaml" }, {
    schemaStore = {
      enable = false,
      url = "",
    },
    schemas = require('schemastore').yaml.schemas(),
  }, { "b0o/SchemaStore.nvim" }),
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    ft = { "yaml" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      lspconfig = {
        settings = {
          yaml = {
            format = {
              prosewrap = "Preserve",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("yaml-companion").setup(opts)
      require("telescope").load_extension("yaml_schema")
    end,
    init = function()
      toggle_fmtoption("l")
      vim.opt.formatoptions:append("o")
    end,
    keys = {
      {
        "<leader>M",
        function()
          require('yaml-companion').open_ui_select()
        end,
        mode = "n",
        desc = "schema=> yaml schema",
      },
    },
  },
}
