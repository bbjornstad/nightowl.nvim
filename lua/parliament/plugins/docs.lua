local env = require("environment.ui")
local key_docs = require("environment.keys").docs
local key_devdocs = key_docs.devdocs
local key_neogen = key_docs.neogen
local key_pandoc = key_docs.auto_pandoc
local key_treedocs = key_docs.treedocs

return {
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      float_win = {
        relative = "editor",
        height = 32,
        width = 100,
        border = env.borders.main,
      },
      previewer_cmd = "glow",
    },
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
    keys = {
      {
        key_devdocs.fetch,
        "<CMD>DevdocsFetch<CR>",
        mode = "n",
        desc = "docs:| dev |=> fetch",
      },
      {
        key_devdocs.install,
        "<CMD>DevdocsInstall<CR>",
        mode = "n",
        desc = "docs:| dev |=> install",
      },
      {
        key_devdocs.uninstall,
        "<CMD>DevdocsUninstall<CR>",
        mode = "n",
        desc = "docs:| dev |=> uninstall",
      },
      {
        key_devdocs.open_float,
        "<CMD>DevdocsOpenFloat<CR>",
        mode = "n",
        desc = "docs:| dev |=> open (float)",
      },
      {
        key_devdocs.buffer_float,
        "<CMD>DevdocsOpenCurrentFloat<CR>",
        mode = "n",
        desc = "docs:| dev |=> buffer (float)",
      },
      {
        key_devdocs.open,
        "<CMD>DevdocsOpen<CR>",
        mode = "n",
        desc = "docs:| dev |=> open",
      },
      {
        key_devdocs.buffer,
        "<CMD>DevdocsOpenCurrent<CR>",
        mode = "n",
        desc = "docs:| dev |=> buffer",
      },
    },
  },
  {
    "jghauser/auto-pandoc.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    keys = {
      {
        key_pandoc.run,
        function()
          require("auto-pandoc").run_pandoc()
        end,
        mode = "n",
        desc = "docs:| convert |=> use pandoc",
        buffer = 0,
        remap = false,
        silent = true,
      },
    },
  },
  {
    "danymat/neogen",
    cmd = { "Neogen" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      languages = {
        lua = {
          template = {
            annotation_convention = "emmylua",
          },
        },
      },
      snippet_engine = "luasnip",
    },
    keys = {
      {
        key_neogen.generate,
        function()
          return require("neogen").generate({ type = "any" })
        end,
        mode = "n",
        desc = "docs:| gen |=> generic docstring",
      },
      {
        key_neogen.class,
        function()
          return require("neogen").generate({ type = "class" })
        end,
        mode = "n",
        desc = "docs:| gen |=> class/obj docstring",
      },
      {
        key_neogen.type,
        function()
          return require("neogen").generate({ type = "type" })
        end,
        mode = "n",
        desc = "docs:| gen |=> type docstring",
      },
      {
        key_neogen.fn,
        function()
          return require("neogen").generate({ type = "func" })
        end,
        mode = "n",
        desc = "docs:| gen |=> function docstring",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/nvim-tree-docs", optional = true },
    },
  },
  {
    "nvim-treesitter/nvim-tree-docs",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true,
      keymap = {
        doc_node_at_cusor = key_treedocs.node_at_cursor,
        doc_all_in_range = key_treedocs.all_in_range,
      },
      --spec_config = {
      --  nu = {
      --    slots = {
      --      description = true,
      --    },
      --    templates = {
      --      "doc-start",
      --      "description",
      --      "doc-end",
      --    },
      --  },
      --},
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    -- keys = {
    --   {
    --     key_treedocs.node_at_cursor,
    --     desc = "docs:| tree |=> node under cursor",
    --   },
    --   {
    --     key_treedocs.all_in_range,
    --     desc = "docs:| tree |=> all in range",
    --   },
    -- },
  },
  {
    "milisims/nvim-luaref",
    event = "VeryLazy",
    opts = {},
    config = function() end,
  },
  {
    "aspeddro/pandoc.nvim",
    opts = {},
    config = function(_, opts)
      require("pandoc").setup(opts)
    end,
    event = "VeryLazy",
  },
  {
    "WERDXZ/nvim-dox",
    opts = {},
    config = function(_, opts) end,
    cmd = "Dox",
  },
}
