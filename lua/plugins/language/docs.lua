local stems = require("environment.keys")
local key_neogen = stems.tool.neogen

return {
  {
    "jghauser/auto-pandoc.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    keys = {
      {
        "<leader>Do",
        function()
          require("auto-pandoc").run_pandoc()
        end,
        mode = "n",
        desc = "docs=> convert with pandoc",
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
        key_neogen .. "d",
        function()
          return require("neogen").generate({ type = "any" })
        end,
        mode = "n",
        desc = "docs=> generic docstring",
      },
      {
        key_neogen .. "c",
        function()
          return require("neogen").generate({ type = "class" })
        end,
        mode = "n",
        desc = "docs=> class/obj docstring",
      },
      {
        key_neogen .. "t",
        function()
          return require("neogen").generate({ type = "type" })
        end,
        mode = "n",
        desc = "docs=> type docstring",
      },
      {
        key_neogen .. "f",
        function()
          return require("neogen").generate({ type = "func" })
        end,
        mode = "n",
        desc = "docs=> function docstring",
      },
    },
  },
}
