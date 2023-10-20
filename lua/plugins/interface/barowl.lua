local env = require("environment.ui")
local sts = require("environment.status")
local util = require("lazyvim.util")
local kcolors = require("funsak.colors").kanacolors

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
        return {
          { sts.recording_status() },
          { " ~ " },
          { " " .. require("local-highlight").match_count(props.buf) },
          { " ~ " },
          { sts.memory_use() },
        }
      end,
      window = {
        margin = { vertical = 0, horizontal = 1 },
        padding = { left = 1, right = 1 },
        placement = { horizontal = "right", vertical = "top" },
        width = "fit",
        options = {
          winblend = 40,
          signcolumn = "no",
          wrap = false,
        },
        winhighlight = {
          InclineNormal = kcolors({ guibg = "sumiInk2" }),
          InclineNormalNC = kcolors({ guibg = "sumiInk1" }),
        },
      },
    },
  },
  {
    "lewis6991/satellite.nvim",
    opts = {
      current_only = true,
      winblend = 50,
      zindex = 40,
      excluded_filetypes = env.ft_ignore_list,
      width = 4,
      search = {
        enable = true,
      },
      diagnostic = {
        enable = true,
        signs = { "-", "=", "≡" },
        min_severity = vim.diagnostic.severity.HINT,
      },
      gitsigns = {
        enable = true,
        signs = {
          add = "┊",
          change = "│",
          delete = "⌁",
        },
      },
      marks = {
        enable = true,
        show_builtins = false,
        key = "m",
      },
      quickfix = {
        signs = { "⫞", "⫤", "⟚" },
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
      "meuter/lualine-so-fancy.nvim",
      "rebelot/kanagawa.nvim",
      "Bekaboo/dropbar.nvim",
      "cbochs/grapple.nvim",
      "wthollingsworth/pomodoro.nvim",
      {
        "jcdickinson/wpm.nvim",
        opts = {
          sample_count = 10,
          sample_interval = 2000,
          percentile = 0.8,
        },
        config = true,
      },
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
          statusline = 10,
          tabline = 1000,
          winbar = 1000,
        },
        disabled_filetypes = {
          lualine = env.ft_ignore_list,
          winbar = vim.list_extend(
            { "NeogitCommitMessage" },
            env.ft_ignore_list
          ),
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
              return string.format("󰩀 %s %s 󰨿", res or "", mode)
            end,
          },
        },
        lualine_b = { { "b:gitsigns_head", icon = "" } },
        lualine_c = {
          {
            "fancy_cwd",
            substitute_home = true,
          },
        },
        lualine_x = {
          {
            function()
              local key = require("grapple").key()
              return "󰓼 ⋊ " .. key .. " ⋉"
            end,
            cond = function()
              return require("grapple").exists()
            end,
          },
          {
            function()
              local wpm = require("wpm")
              return wpm.historic_graph() .. " 󱤘 " .. wpm.wpm() .. "  "
            end,
          },
          {
            function()
              return require("noice").api.status.command.get()
            end,
          },
          { "fancy_location" },
          { "fancy_searchcount" },
        },
        lualine_y = {
          {
            "filetype",
            icon_only = false,
            padding = { left = 1, right = 1 },
          },
          {
            "fancy_lsp_servers",
          },
        },
        lualine_z = {
          {
            "datetime",
            style = "%Y-%m-%d %H:%M",
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
            color = kcolors({ fg = "dragonRed" }),
          },
          {
            function()
              return sts.cust_fname()
            end,
            path = 0,
            symbols = {
              modified = "",
              readonly = "󱪜",
              unnamed = "",
              newfile = "󰜄",
            },
          },
        },
        lualine_y = {
          {
            function()
              return require("pomodoro").statusline()
            end,
            cond = function()
              if not util.has("pomodoro.nvim") then
                return false
              end
              return require("pomodoro").status
            end,
          },
        },
        lualine_z = {
          {
            "tabs",
            mode = 2,
            use_mode_colors = true,
            max_length = vim.o.columns / 6,
            fmt = function(name, context)
              -- Show + if buffer is modified in tab
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]
              local mod = vim.fn.getbufvar(bufnr, "&mod")
              local thisdir = vim.fn.getcwd(winnr, context.tabnr)
              local dirtail = vim.fn.fnamemodify(thisdir, ":t")

              return (dirtail or name) .. (mod == 1 and " +" or "")
            end,
          },
        },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "%{%v:lua.dropbar.get_dropbar_str()%}",
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = {
              error = env.icons.diagnostic.Error,
              warn = env.icons.diagnostic.Warn,
              info = env.icons.diagnostic.Info,
              hint = env.icons.diagnostic.Hint,
            },
          },
        },
        lualine_y = {
          {
            "diff",
            colored = true,
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
            source = sts.diff_source,
          },
        },
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "%{%v:lua.dropbar.get_dropbar_str()%}",
          },
        },
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = "*",
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
          ["]"] = function()
            local dutil = require("dropbar.utils")
            local thismenu = dutil.menu.get_current()
            if not thismenu then
              return
            end
            require("dropbar.api").select_next_context()
          end,
          ["["] = function()
            local dutil = require("dropbar.utils")
            local thismenu = dutil.menu.get_current()
            if not thismenu then
              return
            end
            return thismenu.prev_menu
          end,
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
      icons = {
        enable = true,
        bar = {
          separator = "  ",
          extends = "...",
        },
        menu = {
          separator = " ",
          indicator = "⨽ ",
        },
        kinds = {
          use_devicons = true,
          symbols = require("funsak.table").mopts({
            Array = "󰅪 ",
            Boolean = " ",
            BreakStatement = "󰙧 ",
            Call = "󰃷 ",
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
            Function = "󰊕 ",
            H1Marker = "󰉫 ", -- Used by markdown treesitter parser
            H2Marker = "󰉬 ",
            H3Marker = "󰉭 ",
            H4Marker = "󰉮 ",
            H5Marker = "󰉯 ",
            H6Marker = "󰉰 ",
            Identifier = "󰀫 ",
            IfStatement = "󰇉 ",
            Interface = " ",
            Keyword = "󰌋 ",
            List = "󰅪 ",
            Log = "󰦪 ",
            Lsp = " ",
            Macro = "󰁌 ",
            MarkdownH1 = "󰉫 ", -- Used by builtin markdown source
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
            Terminal = " ",
            Text = " ",
            Type = " ",
            TypeParameter = "󰆩 ",
            Unit = " ",
            Value = "󰎠 ",
            Variable = "󰀫 ",
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
        desc = "lsp=> pick grains from breadcrumbs",
      },
      {
        "g_",
        function()
          require("dropbar.api").pick()
        end,
        mode = "n",
        desc = "lsp=> pick grains from breadcrumbs",
      },
    },
  },
  {
    "lukas-reineke/virt-column.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("virt-column").setup(opts)
    end,
    opts = {
      enabled = true,
      char = "║",
    },
  },
}
