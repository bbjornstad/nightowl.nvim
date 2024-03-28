local key_lsp = require("environment.keys").lsp

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        text = { "codespell", "vale" },
      },
    },
    config = function(_, opts)
      local custom = require("funsak.table").strip(opts, { "custom" })
      local lint = require("lint")
      for name, cfg in pairs(custom) do
        lint.linters[name] = cfg
      end
      lint.linters_by_ft = opts.linters_by_ft or {}
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        callback = function(ev)
          require("lint").try_lint()
        end,
        desc = "󰉂 lsp:| lint |=> Buf{Enter,WritePost}",
      })
    end,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        key_lsp.lint.lint,
        function()
          require("lint").try_lint()
        end,
        mode = "n",
        desc = "lsp:| lint |=> try",
      },
    },
  },
  {
    "rshkarin/mason-nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    opts = {
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-nvim-lint").setup(opts)
    end,
  },
  {
    "chrisgrieser/nvim-rulebook",
    event = "LspAttach",
    keys = {
      {
        key_lsp.lint.ignore,
        function()
          require("rulebook").ignoreRule()
        end,
        mode = "n",
        desc = "lsp:| lint |=> ignore rule",
      },
      {
        key_lsp.lint.lookup,
        function()
          require("rulebook").lookupRule()
        end,
        mode = "n",
        desc = "lsp:| lint |=> lookup rule",
      },
    },
    config = function(_, opts)
      require("rulebook").setup(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = {
          suffix = function(diag)
            return require("rulebook").hasDocs(diag) and " 󱙽" or ""
          end,
        },
      })
    end,
  },
}
