-- vim: set ft=lua sts=2 sw=2 ts=2 et:
local key_lsp = require("environment.keys").lsp
return {
  {
    "mfussenegger/nvim-lint",
    dependencies = { { "rshkarin/mason-nvim-lint", optional = true } },
    enabled = true,
    opts = { linters_by_ft = { text = {} } },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft or {}
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
        desc = "linting after writing buffer",
      })
    end,
    event = "VeryLazy",
    keys = {
      {
        key_lsp.auxiliary.lint,
        function()
          require("lint").try_lint()
        end,
        mode = "n",
        desc = "lsp=> try lint",
      },
    },
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-lint",
    },
    event = { "LspAttach" },
  },
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {
      formatters_by_ft = {
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },

      format_on_save = { timeout_ms = 3000, lsp_fallback = true },
      log_level = vim.log.levels.WARN,
      notify_on_error = true,
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
    keys = {
      {
        key_lsp.auxiliary.format,
        function()
          require("conform").format({ async = true })
        end,
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
        key_lsp.auxiliary.rules.ignore,
        function()
          require("rulebook").ignoreRule()
        end,
        mode = "n",
        desc = "lsp=> ignore lint rule",
      },
      {
        key_lsp.auxiliary.rules.lookup,
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
      "stevearc/dressing.nvim",        -- Optional, better picker
      "nvim-telescope/telescope.nvim", -- Optional, better picker
    },
    main = "plf",
    opts = {
      data_dir = vim.fn.expand(vim.fn.stdpath("state") .. "/picklspformat/"),
      when_unset = "pick",
      set_on_pick = true,
      find_project = true,
      find_patterns = { ".git" },
    },
  },
}
