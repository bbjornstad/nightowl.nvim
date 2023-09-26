local mapn = require("environment.keys").map("n")
local toggle_fmtoption = require("uutils.text").toggle_fmtopt
local def = require("uutils.lazy").implang
local masonry = require('uutils.lazy').masonry

return {
  def({ "yaml", "yml" }, "yamlfmt", "yamllint"),
  masonry({ name = "yamlls", lang = "yaml" }, {
    schemaStore = {
      enable = false,
      url = "",
    },
    schemas = require('schemastore').yaml.schemas(),
  }, { "b0o/SchemaStore.nvim" }),
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   dependencies = { "neovim/nvim-lspconfig", "b0o/SchemaStore.nvim" },
  --   opts = function(_, opts)
  --     opts = vim.tbl_deep_extend("force", opts, {
  --       handlers = {
  --         yamlls = function()
  --           require("lspconfig").yamlls.setup({
  --             settings = {
  --               yaml = {
  --                 schemaStore = {
  --                   enable = false,
  --                   url = "",
  --                 },
  --                 schemas = require("schemastore").yaml.schemas(),
  --               },
  --             },
  --           })
  --         end,
  --       },
  --     })
  --   end,
  -- },
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
      vim.opt.formatoptions = vim.opt.formatoptions + "o"
      mapn(
        "<leader>M",
        require("yaml-companion").open_ui_select,
        { desc = "schema=> select YAML schemas" }
      )
    end,
  },
}
