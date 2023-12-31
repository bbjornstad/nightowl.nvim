local lz = require("funsak.lazy")
local key_lsp = require("environment.keys").lsp
local slow_format_filetypes = {}

return {
  {
    "mfussenegger/nvim-lint",
    opts = { linters_by_ft = { text = {} } },
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
        key_lsp.auxiliary.lint,
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
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    keys = {
      {
        key_lsp.auxiliary.format.default,
        function()
          require("conform").format({ async = true })
        end,
        mode = "n",
        desc = "lsp:buf| fmt |=> apply",
      },
      {
        key_lsp.auxiliary.format.list,
        function()
          require("conform").list_formatters(0)
        end,
        mode = "n",
        desc = "lsp:buf| fmt |=> list formatters",
      },
      {
        key_lsp.auxiliary.format.info,
        "<CMD>ConformInfo<CR>",
        mode = "n",
        desc = "lsp:| fmt |=> info",
      },
    },
  },
  {
    "chrisgrieser/nvim-rulebook",
    event = "LspAttach",
    keys = {
      {
        key_lsp.auxiliary.rules.ignore,
        function()
          require("rulebook").ignoreRule()
        end,
        mode = "n",
        desc = "lsp:| lint |=> ignore rule",
      },
      {
        key_lsp.auxiliary.rules.lookup,
        function()
          require("rulebook").lookupRule()
        end,
        mode = "n",
        desc = "lsp:| lint |=> lookup rule",
      },
    },
  },
  {
    "fmbarina/pick-lsp-formatter.nvim",
    event = "LspAttach",
    dependencies = {
      "stevearc/dressing.nvim", -- Optional, better picker
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
    keys = {
      {
        key_lsp.auxiliary.format.pick,
        function()
          require("plf").format()
        end,
        mode = "n",
        desc = "lsp:| fmt |=> pick",
      },
    },
  },
}
