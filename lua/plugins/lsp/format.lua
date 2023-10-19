-- vim: set ft=lua sts=2 sw=2 ts=2 et:
local key_lsp = require("environment.keys").lsp:leader()
return {
  {
    "mfussenegger/nvim-lint",
    enabled = false,
    opts = {
      linters_by_ft = {
        text = { "vale" },
      },
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft or {}

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = require("lint").try_lint,
        desc = "linting after writing buffer",
      })
    end,
    event = "VeryLazy",
    keys = {
      {
        key_lsp .. "l",
        function()
          require("lint").try_lint()
        end,
        mode = "n",
        desc = "lsp=> try lint",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    keys = {
      {
        key_lsp .. "f",
        vim.lsp.buf.format,
        mode = "n",
        desc = "lsp=> format buffer",
      },
    },
  },
  {
    "chrisgrieser/nvim-rulebook",
    event = "VeryLazy",
    keys = {
      {
        key_lsp .. "I",
        function()
          require("rulebook").ignoreRule()
        end,
        mode = "n",
        desc = "lsp=> ignore lint rule",
      },
      {
        key_lsp .. "L",
        function()
          require("rulebook").lookupRule()
        end,
        mode = "n",
        desc = "lsp=> lookup lint rule",
      },
    },
  },
  {
    "fmbarina/pick-lsp-formatter.nvim",
    event = "VeryLazy",
    dependencies = {
      "stevearc/dressing.nvim", -- Optional, better picker
      "nvim-telescope/telescope.nvim", -- Optional, better picker
    },
    main = "plf",
    lazy = true,
    opts = {
      data_dir = vim.fn.expand(vim.fn.stdpath("state") .. "/picklspformat/"),
      when_unset = "pick",
      set_on_pick = true,
      find_project = true,
      find_patterns = { ".git" },
    },
  },
}
