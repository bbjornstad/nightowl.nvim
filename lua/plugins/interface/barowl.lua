local env = require("environment.ui")
local sts = require('environment.statusline')
local util = require("lazyvim.util")
local kcolors = env.kanacolors

--function custom_fname:init(options)
--  local default_status_colors = kcolors({
--    saved = "lotusBlue3",
--    modified = "lotusGreen",
--  })
--  custom_fname.super.init(self, options)
--  self.status_colors = {
--    saved = highlight.create_component_highlight_group(
--      { fg = default_status_colors.saved },
--      "filename_status_saved",
--      self.options
--    ),
--    modified = highlight.create_component_highlight_group(
--      { fg = default_status_colors.modified },
--      "filename_status_modified",
--      self.options
--    ),
--  }
--  if self.options.color == nil then
--    self.options.color = ""
--  end
--end
--
--function custom_fname:update_status()
--  local data = custom_fname.super.update_status(self)
--  data = highlight.component_format_highlight(
--    vim.bo.modified and self.status_colors.modified or self.status_colors.saved
--  ) .. data
--  return data
--end
--
--local function memory_use()
--  local free = (1 - (vim.loop.get_free_memory() / vim.loop.get_total_memory()))
--    * 100
--  return ("󱈯 %.2f"):format(free) .. "%"
--end
--
--local function pom_status()
--  local ok, pom = pcall(require, "pomodoro")
--  return ok and pom.statusline
--end
--
--local function escape_wait()
--  local ok, m = pcall(require, "better_escape")
--  return ok and m.waiting and " 󱎙 " or ""
--end
--
--local function diff_source()
--  local gitsigns = vim.b.gitsigns_status_dict
--  if gitsigns then
--    return {
--      added = gitsigns.added,
--      modified = gitsigns.changed,
--      removed = gitsigns.removed,
--    }
--  end
--end
--
--local function recording_status()
--  if not require("noice").api.status.mode.has() then
--    return
--  end
--  local recording = require("noice").api.status.mode.get()
--  return recording .. " | "
--end
--
--local function codeium()
--  if not util.has("codeium.vim") then
--    return
--  end
--  local status = vim.fn["codeium#GetStatusString"]()
--  return status .. " | "
--end

return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    module = false,
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "jcdickinson/wpm.nvim",
        opts = {
          sample_count = 10,
          sample_interval = 2000,
          percentile = 0.8,
        },
        config = true,
      },
      "tzachar/local-highlight.nvim",
    },
    opts = {
      render = function(props)
        return {
          { sts.codeium() },
          { sts.recording_status(), unpack(kcolors({ guifg = "dragon-red" })) },
          {
            require("wpm").historic_graph(),
          },
          { "  / 󰌓 " },
          { require("wpm").wpm() },
          { " | " },
          { " " },
          { require("local-highlight").match_count(props.buf) },
          { " | " },
          { sts.memory_use() },
        }
      end,
      window = {
        -- overlap = { winbar = false, tabline = false },
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
      width = 2,
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
          change = "│	",
          delete = "═",
        },
      },
      marks = {
        enable = true,
        show_builtins = false,
        key = "m",
      },
      quickfix = {
        signs = { "-", "=", "≡" },
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
        lualine_a = { { "fancy_mode", width = 7 } },
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
              require("grapple").exists()
            end,
          },
          { function() require("noice").api.status.command.get() end },
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
            function() require("noice").api.status.mode.get() end,
            cond = function() require("noice").api.status.mode.has() end,
            color = kcolors({ fg = "dragonRed" }),
          },
          {
            function() sts.cust_fname() end,
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
            function() require("pomodoro").statusline() end,
            cond = function()
              if not util.has("pomodoro") then
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
              error = require("lazyvim.config").icons.diagnostics.Error,
              warn = require("lazyvim.config").icons.diagnostics.Warn,
              info = require("lazyvim.config").icons.diagnostics.Info,
              hint = require("lazyvim.config").icons.diagnostics.Hint,
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
            local api = require("dropbar.api")
            local thismenu = api.utils.menu.get_current()
            if not thismenu then
              return
            end
            api.select_next_context()
          end,
          ["["] = function()
            local api = require("dropbar.api")
            local thismenu = api.utils.menu.get_current()
            if not thismenu then
              return
            end
            return thismenu.prev_menu
          end,
          ["q"] = function()
            local api = require("dropbar.api")
            local thismenu = api.api.utils.menu.get_current()
            if not thismenu then
              return
            end
            thismenu:close()
          end,
        },
      },
      bar = {
        padding = { left = 2, right = 2 },
      },
      icons = {
        bar = {
          separator = "  ",
          extends = "  ",
        },
        menu = {
          separator = " ",
          indicator = "",
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
  }
  
