local kenv = require("environment.keys")
local key_yaml = kenv.lang.yaml
local lz = require("funsak.lazy")

local toggle_fmtoption = require("uutils.text").toggle_fmtopt

return {
  lz.lspsrv("yamlls", {
    server = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
      settings = {
        redhat = { telemetry = { enabled = false } },
        yaml = {
          validate = true,
          format = true,
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = require("schemastore").yaml.schemas(),
          schemaDownload = { enable = true },
        },
      },
    },
    dependencies = {
      { "b0o/SchemaStore.nvim" },
    },
  }),
  lz.lsplnt("yamllint", { "yaml", "yml" }),
  lz.lspfmt("yamlfmt", { "yaml", "yml" }),
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
    opts = function(_, opts)
      opts = opts or {}
      opts.lspconfig = vim.tbl_deep_extend("force", {
        settings = {
          yaml = {
            format = {
              prosewrap = "Preserve",
            },
          },
        },
      }, opts.lspconfig or {})
    end,
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
        key_yaml.schema,
        function()
          require("yaml-companion").open_ui_select()
        end,
        mode = "n",
        desc = "schema=> yaml schema",
      },
    },
  },
}