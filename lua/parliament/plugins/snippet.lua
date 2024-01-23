local env = require("environment.ui")
local key_scope = require("environment.keys").scope
local key_snippet = require("environment.keys").tool.snippet

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      { "honza/vim-snippets", optional = true },
      { "rafamadriz/friendly-snippets", optional = true },
    },
    event = "VeryLazy",
    opts = {
      vscode = true,
      snipmate = true,
      history = true,
      delete_check_events = "TextChanged",
    },
    config = function(_, opts)
      opts = opts or {}
      if opts.custom then
        require("luasnip.loaders.from_vscode").lazy_load({
          paths = { vim.fn.joinpath(vim.fn.stdpath("config"), "snippets") },
        })
      end
      opts.custom = nil
      if opts.vscode then
        require("luasnip.loaders.from_vscode").lazy_load()
      end
      opts.vscode = nil
      if opts.snipmate then
        require("luasnip.loaders.from_snipmate").lazy_load()
      end
      opts.snipmate = nil
      require("luasnip").setup(opts)
    end,
  },
  { "honza/vim-snippets", config = false, event = "VeryLazy" },
  { "rafamadriz/friendly-snippets", config = false, event = "VeryLazy" },
  {
    "benfowler/telescope-luasnip.nvim",
    module = "telescope._extensions.luasnip",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("telescope").load_extension("luasnip")
    end,
    keys = {
      {
        key_scope.luasnip,
        function()
          require("telescope").extensions.luasnip.luasnip()
        end,
        mode = "n",
        desc = "scope.ext=> snippets",
      },
    },
  },
  {
    "chrisgrieser/nvim-scissors",
    config = function(_, opts)
      require("scissors").setup(opts)
    end,
    opts = {
      snippetDir = vim.fs.joinpath(vim.fn.stdpath("config"), "snippets"),
      editSnippetPopup = {
        border = env.borders.main,
      },
      jsonFormatter = "yq",
    },
    event = "VeryLazy",
    keys = {
      {
        key_snippet.add,
        function()
          require("scissors").addNewSnippet()
        end,
        mode = "n",
        desc = "snip=> add new",
      },
      {
        key_snippet.edit,
        function()
          require("scissors").editSnippet()
        end,
        mode = "n",
        desc = "snip=> add new",
      },
    },
  },
}
