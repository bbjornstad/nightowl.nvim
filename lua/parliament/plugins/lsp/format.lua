local lz = require("funsak.lazy")
local key_lsp = require("environment.keys").lsp
local slow_format_filetypes = {}

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        ["*"] = { "injected" },
        ["_"] = { "trim_newlines", "trim_whitespace" },
      },

      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end

        local function on_format(err)
          if err and err:match("timeout$") then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        return { timeout_ms = 1000, lsp_fallback = true }, on_format
      end,
      format_after_save = function(bufnr)
        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { lsp_fallback = true }
      end,
      log_level = vim.log.levels.WARN,
      notify_on_error = true,
    },
    config = function(_, opts)
      require("conform.formatters.injected").options.ignore_errors = true
      require("conform").setup(opts)

      -- defines new format command
      vim.api.nvim_create_user_command("OwlFormat", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line =
            vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({
          async = true,
          lsp_fallback = true,
          range = range,
        })
      end, { range = true })
      vim.api.nvim_create_user_command("OwlFormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "󱡠 lsp:buf| fmt.auto |=> disable",
        bang = true,
      })
      vim.api.nvim_create_user_command("OwlFormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "󱡠 lsp:buf| fmt.auto |=> enable",
      })
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
      {
        key_lsp.format.default,
        function()
          require("conform").format({ async = true })
        end,
        mode = "n",
        desc = "lsp:buf| fmt |=> apply",
      },
      {
        key_lsp.format.list,
        function()
          require("conform").list_formatters(0)
        end,
        mode = "n",
        desc = "lsp:buf| fmt |=> list formatters",
      },
      {
        key_lsp.format.info,
        "<CMD>ConformInfo<CR>",
        mode = "n",
        desc = "lsp:| fmt |=> info",
      },
    },
  },
}
