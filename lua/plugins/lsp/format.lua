-- local key_ui = require('environment.keys').stems.base.ui

return {
  {
    "mfussenegger/nvim-lint",
    enabled = false,
    opts = {
      text = { 'vale', },
    },
    config = function(_, opts)
      require('lint').linters_by_ft = opts

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = require('lint').try_lint,
        desc = "linting after writing buffer"
      })
    end,
    event = "LspAttach",
    keys = {
      {
        "gL",
        function()
          require('lint').try_lint()
        end,
        mode = "n",
        desc = "lsp=> try lint"
      },
    }
  },
  {
    "mhartington/formatter.nvim",
    enabled = false,
    opts = {
      logging = true,
      log_level = vim.log.levels.INFO,
      filetype = {
        ["*"] = require('formatter.filetypes.any').remove_trailing_whitespace
      }
    },
    config = function(_, opts)
      require('formatter').setup(opts)
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        command = "FormatWriteLock"
      })
    end,
    keys = {
      {
        "gF",
        vim.lsp.buf.format,
        mode = "n",
        desc = "lsp=> format buffer"
      }
    }
  }
}
