local env = require("environment.ui")
local sts = require("environment.status")
local util = require("lazyvim.util")

local function lubar()
  local res = vim
    .iter(vim.list_extend({ "neogitcommitmessage" }, env.ft_ignore_list))
    :filter(function(t)
      return not string.find(t, "oil")
    end)
    :totable()
  return res
end

local function inclinate(results, opts)
  opts = opts or {}
  local ret = vim.tbl_deep_extend("force", { results }, opts)
  return ret
end

local function incliner(fn)
  local function wrap(props, opts)
    local res = fn(props, opts)
    return inclinate(res, function(t)
      return { t, cond = opts.cond or true }
    end)
  end

  return wrap
end

return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "tzachar/local-highlight.nvim",
    },
    opts = {
      render = function(props)
        return vim.tbl_map(function(it)
          local ret = (vim.is_callable(it.cond) and it.cond() or it.cond)
              and it[1]
            or nil
          return ret
        end, {
          { { "⟓:║ " }, cond = true },
          sts.count.search(props, { icon = "󱊄", separator = "⦙" }),
          sts.count.selection(props, { icon = "󱈅", separator = "⦙" }),
          sts.progress(props, {
            icon = { glyph = "󱋫", location = "prefix" },
            separator = "⦙",
          }),
          sts.grapple(props, { icon = "⨳", separator = "⦙" }),
          sts.match_local_hl(props, { icon = "󰾹", separator = "⦙" }),
          sts.fileinfo(props, { formatter = "╘╡ %s %s ╞╛" }),
        })
      end,
      hide = {
        cursorline = false,
        focused_win = false,
        only_win = false,
      },
      highlight = {
        groups = {
          InclineNormal = {
            default = true,
            group = "NormalFloat",
          },
          InclineNormalNC = {
            default = true,
            group = "NormalFloat",
          },
        },
      },
      window = {
        margin = { vertical = 0, horizontal = 1 },
        padding = 1,
        padding_char = " ",
        placement = { horizontal = "right", vertical = "top" },
        width = "fit",
        options = {
          signcolumn = "no",
          wrap = false,
        },
        winhighlight = {
          active = {
            EndOfBuffer = "None",
            Normal = "InclineNormal",
            Search = "None",
          },
          inactive = {
            EndOfBuffer = "None",
            Normal = "InclineNormalNC",
            Search = "None",
          },
        },
        zindex = 20,
      },
    },
  },
  {
    "lewis6991/satellite.nvim",
    opts = {
      current_only = true,
      winblend = 20,
      zindex = 10,
      excluded_filetypes = env.ft_ignore_list,
      width = 4,
      handlers = {
        search = {
          enable = true,
        },
        diagnostic = {
          enable = true,
          signs = { "-", "=", "≡" },
          min_severity = vim.diagnostic.severity.hint,
        },
        gitsigns = {
          enable = true,
          signs = {
            add = "│",
            change = "┆",
            delete = "⦚",
          },
        },
        marks = {
          enable = true,
          show_builtins = false,
          key = "m",
        },
        quickfix = {
          signs = { "↼", "⥚", "⦧" },
        },
      },
    },
    config = true,
    event = "VeryLazy",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "folke/noice.nvim",
      "nvim-tree/nvim-web-devicons",
      "rebelot/kanagawa.nvim",
      "cbochs/grapple.nvim",
      "wthollingsworth/pomodoro.nvim",
      "jcdickinson/wpm.nvim",
      "Lamby777/timewasted.nvim",
    },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        icons_enabled = true,
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
        disabled_filetypes = {
          statusline = env.ft_ignore_list,
          winbar = lubar(),
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(mode, _)
              local res
              for k, v in pairs(env.icons.lualine.mode) do
                if string.gmatch(mode, k) then
                  res = env.icons.lualine.mode[mode]
                  break
                end
              end
              return string.format("󰩀 %s%s 󰨿", res or "", mode)
            end,
          },
        },
        lualine_b = {
          {
            "b:gitsigns_head",
            icon = " ",
            separator = "┊",
          },
          {
            "diff",
            colored = true,
            symbols = env.icons.gitdiff,
            source = sts.diff_source,
          },
        },
        lualine_c = {
          {
            function()
              local res = require("timewasted").get_fmt()
              return res
            end,
            icon = "󱪑",
            separator = "┊",
          },
          {
            function()
              return sts.wpm()
            end,
            cond = function()
              local status, wpm = pcall(require, "wpm")
              return wpm.wpm() >= 10 and status
            end,
            separator = "┊",
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.command.get()
            end,
            icon = " ",
            separator = "┊",
          },
        },
        lualine_y = {
          {
            "filetype",
            icon_only = false,
            padding = { left = 1, right = 1 },
          },
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              clients = vim.tbl_map(function(t)
                return t.name
              end, clients)
              return table.concat(
                vim.tbl_filter(function(t)
                  return not vim.tbl_contains({
                    "null-ls",
                    "diagnosticls",
                    "efm",
                  }, t)
                end, clients),
                ":"
              )
            end,
            icon = "󰇗 ",
          },
        },
        lualine_z = {
          {
            "datetime",
            style = "%H:%M ~ %y-%m-%d",
            icon = "󱇼 ",
          },
        },
      },
      tabline = {
        lualine_a = {
          {
            "buffers",
            show_filename_only = false,
            mode = 4,
            use_mode_colors = true,
            icon = "󱏒 ",
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return require("noice").api.status.mode.has()
            end,
            color = util.ui.fg("DiagnosticError"),
            icon = "󰻃 ",
          },
          {
            function()
              return sts.cust_fname()
            end,
            path = 0,
            symbols = env.icons.modifications,
          },
        },
        lualine_y = {
          {
            function()
              return sts.pulse_status()
            end,
            cond = function()
              if not util.has("pulse.nvim") or not sts.pulse_status() then
                return false
              end
              return true
            end,
          },
          {
            function()
              return sts.memory_use()
            end,
            separator = "┊",
          },
        },
        lualine_z = {
          {
            "tabs",
            mode = 2,
            use_mode_colors = true,
            max_length = vim.o.columns / 6,
            symbols = {
              modified = " 󰰾",
            },
            fmt = function(name, context)
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]
              local mod = vim.fn.getbufvar(bufnr, "&mod")
              local thisdir = vim.fn.getcwd(winnr, context.tabnr)
              local dirtail = vim.fn.fnamemodify(thisdir, ":t")
              local lzroot = util.lualine.root_dir({
                cwd = true,
                subdirectory = true,
                icon = "󱞋 ",
              })
              local cond = lzroot.cond
              local final
              if cond ~= nil and (vim.is_callable(cond) and cond()) or cond then
                final = lzroot[1]()
              else
                final = dirtail
              end

              final = (mod == 1 and "⦗ " or "⦋ ")
                .. final
                .. (mod == 1 and " ⦘" or " ⦌")

              return final
            end,
          },
        },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "%{%v:lua.dropbar.get_dropbar_str()%}" },
        lualine_x = {
          {
            "diagnostics",
            sources = {
              "nvim_lsp",
              "nvim_diagnostic",
              "nvim_workspace_diagnostic",
            },
            sections = { "error", "warn", "info", "hint" },
            symbols = {
              error = env.icons.diagnostic.Error,
              warn = env.icons.diagnostic.Warn,
              info = env.icons.diagnostic.Info,
              hint = env.icons.diagnostic.Hint,
            },
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "%{%v:lua.dropbar.get_dropbar_str()%}" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        "quickfix",
        "aerial",
        "fzf",
        "lazy",
        "man",
        "neo-tree",
        "nerdtree",
        "nvim-tree",
        "nvim-dap-ui",
        "overseer",
        "symbols-outline",
        "toggleterm",
        "trouble",
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "VimEnter",
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
    opts = {
      general = {
        enable = false,
      },
      menu = {
        win_configs = {
          style = "minimal",
          border = env.borders.main,
        },
        quick_navigation = true,
        entry = {
          padding = {
            left = 2,
            right = 2,
          },
        },
        keymaps = {
          ["q"] = function()
            local api = require("dropbar.utils")
            local thismenu = api.menu.get_current()
            if not thismenu then
              return
            end
            thismenu:close()
          end,
          ["<leader>"] = function()
            local menu = require("dropbar.utils").menu.get_current()
            menu:fuzzy_find_open()
          end,
        },
      },
      bar = {
        padding = { left = 2, right = 2 },
      },
      win_configs = {
        border = env.borders.main,
        style = "minimal",
      },
      icons = {
        enable = true,
        ui = {
          bar = {
            separator = " 󰧛 ",
            extends = "",
          },
          menu = {
            separator = " 󰘠 ",
            indicator = "󱟮 ",
          },
        },
        kinds = {
          use_devicons = true,
          symbols = require("funsak.table").mopts({
            Array = "󰅪 ",
            Boolean = " ",
            BreakStatement = "󰙧 ",
            Call = "󱅥 ",
            CaseStatement = "󱃙 ",
            Class = " ",
            Color = "󰏘 ",
            Constant = "󰏿 ",
            Constructor = " ",
            ContinueStatement = "→ ",
            Copilot = " ",
            Declaration = "󰙠 ",
            Delete = "󰩺 ",
            DoStatement = "󰑖 ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = "󰈔 ",
            Folder = "󰉋 ",
            ForStatement = "󰑖 ",
            Function = "󰡱 ",
            H1Marker = "󰉫 ", -- used by markdown treesitter parser
            H2Marker = "󰉬 ",
            H3Marker = "󰉭 ",
            H4Marker = "󰉮 ",
            H5Marker = "󰉯 ",
            H6Marker = "󰉰 ",
            Identifier = "󰓽 ",
            IfStatement = "󰇉 ",
            Interface = " ",
            Keyword = "󰌋 ",
            List = "󰅪 ",
            Log = "󰦪 ",
            Lsp = " ",
            Macro = "󰷵 ",
            MarkdownH1 = "󰉫 ", -- used by builtin markdown source
            MarkdownH2 = "󰉬 ",
            MarkdownH3 = "󰉭 ",
            MarkdownH4 = "󰉮 ",
            MarkdownH5 = "󰉯 ",
            MarkdownH6 = "󰉰 ",
            Method = "󰆧 ",
            Module = "󰏗 ",
            Namespace = "󰅩 ",
            Null = "󰢤 ",
            Number = "󰎠 ",
            Object = "󰅩 ",
            Operator = "󰆕 ",
            Package = "󰆦 ",
            Pair = "󰅪 ",
            Property = " ",
            Reference = "󰦾 ",
            Regex = " ",
            Repeat = "󰑖 ",
            Scope = "󰅩 ",
            Snippet = "󰩫 ",
            Specifier = "󰦪 ",
            Statement = "󰅩 ",
            String = "󰉾 ",
            Struct = " ",
            SwitchStatement = "󰺟 ",
            Text = " ",
            Type = " ",
            TypeParameter = "󰆩 ",
            Unit = " ",
            Value = "󰎠 ",
            Variable = "󱃼 ",
            WhileStatement = "󰑖 ",
          }, env.icons.kinds),
        },
      },
    },
    keys = {
      {
        "g-",
        function()
          require("dropbar.api").pick()
        end,
        mode = "n",
        desc = "::win=> breadcrumbs",
      },
    },
  },
  {
    "jcdickinson/wpm.nvim",
    opts = {
      sample_count = 10,
      sample_interval = 2000,
      percentile = 0.8,
    },
    config = true,
  },
}
