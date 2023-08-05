local env = require("environment.ui")
local mapn = require("environment.keys").map({ "n" })
local mapx = vim.keymap.set
local df = require("uutils.functional").lazy_defer

local bdelete_handler =
  "<CMD>lua require('nvim-smartbufs').close_current_buffer()<CR>"
local bdeletebang_handler = bdelete_handler
local bnext_handler =
  "<CMD>lua require('nvim-smartbufs').goto_next_buffer()<CR>"
local bprev_handler =
  "<CMD>lua require('nvim-smartbufs').goto_prev_buffer()<CR>"
local quit_handler = "<CMD>quit<CR>"
local quitbang_handler = "<CMD>quit!<CR>"
local quitall_handler = "<CMD>quitall<CR>"
local quitallbang_handler = "<CMD>quitall!<CR>"

-- local bdelete_handler = df(wutils.bdelete_handler)
-- local bdeletebang_handler = df(wutils.bdeletebang_handler)
-- local bnext_handler = df(wutils.bnext_handler)
-- local bprev_handler = df(wutils.bprev_handler)
--
-- local quit_handler = df(wutils.quit_handler)
-- local quitbang_handler = df(wutils.quitbang_handler)
-- local quitall_handler = df(wutils.quitall_handler)
-- local quitallbang_handler = df(wutils.quitallbang_handler)

return {
  {
    "williamboman/mason.nvim",
    opts = { ui = { border = env.borders.main_accent } },
  },
  {
    "folke/noice.nvim",
    opts = {
      -- debug = true,
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = true,
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,
      },
      views = {
        popup = {
          border = {
            style = env.borders.main,
            padding = { 1, 2 },
          },
        },
        cmdline_popup = {
          position = { row = 16, col = "50%" },
          size = {
            width = math.max(80, vim.opt.textwidth:get()),
          },
          -- put it on top of everything else that could exist below (we picked
          -- 1200 because it was larger than the largest present zindex
          -- definition for any other component)
          zindex = 100,
          border = { style = env.borders.main, padding = { 1, 2 } },
          win_options = {
            winhighlight = {
              -- Normal = "Normal",
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        popupmenu = {
          relative = "editor",
          position = { row = 16, col = "50%" },
          size = { width = 80, height = "auto" },
          -- once again, put it on top of everything else that could exist below.
          -- 1200 rationale still holds here too.
          zindex = 100,
          border = { style = env.borders.main, padding = { 1, 2 } },
          win_options = {
            winhighlight = {
              -- Normal = "Normal",
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        hover = {
          view = "popup",
          size = {
            max_height = 30,
            max_width = 120,
          },
          border = {
            style = env.borders.main,
            padding = { 1, 2 },
          },
        },
        confirm = {
          border = {
            style = env.borders.main,
            padding = { 1, 2 },
            text = { "test" },
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        notify = {
          border = { style = env.borders.main, padding = { 1, 2 } },
          relative = "editor",
        },
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing file symbols...",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "msg_show",
            kind = "progress",
            find = "checking document",
          },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Diagnosing",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing full semantic tokens",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Searching in files...",
          },
          opts = {
            skip = true,
          },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing reference...",
          },
          opts = {
            skip = true,
          },
        },
      },
    },
  },
  {
    "nvim-focus/focus.nvim",
    opts = {
      enable = true,
      commands = true,
      autoresize = {
        enable = true,
      },
      ui = {
        absolutenumber_unfocussed = true,
        hybridnumber = true,
        winhighlight = false,
        cursorline = true,
        cursorcolumn = false,
        colorcolumn = {
          enable = true,
          list = "+1",
        },
      },
    },
    event = "VeryLazy",
    init = function()
      local focus = require("focus")
      local focusmap = function(direction)
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>w" .. direction,
          -- this comes directly from  the focus nvim readme but we want to use the capital letter mappings for consistency
          ":lua require'focus'.split_command('"
            .. string.lower(direction)
            .. "')<CR>",
          { silent = true }
        )
      end
      -- Use `<Leader>h` to split the screen to the left, same as command FocusSplitLeft etc
      focusmap("h")
      focusmap("j")
      focusmap("k")
      focusmap("l")
      mapx(
        "n",
        "<leader>uWw",
        focus.focus_toggle,
        { desc = "focus=> toggle focus win-sizer" }
      )
      mapx(
        "n",
        "<leader>uWo",
        focus.focus_enable,
        { desc = "focus=> enable focus win-sizer" }
      )
      mapx(
        "n",
        "<leader>uWq",
        focus.focus_disable,
        { desc = "focus=> disable focus win-sizer" }
      )
      mapx(
        "n",
        "<leader>uWM",
        focus.focus_max_or_equal,
        { desc = "focus=> toggle maximized focus" }
      )
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.top_down = true
      opts.render = "compact"
      opts.on_open = function(win)
        vim.api.nvim_win_set_config(win, {
          border = env.borders.main,
        })
      end
    end,
  },
  {
    "johann2357/nvim-smartbufs",
    opts = {},
    event = "VeryLazy",
    config = function() end,
    keys = {
      {
        "qq",
        quit_handler,
        mode = { "n", "v" },
        desc = "buf=> quit current buffer",
      },
      {
        "qQ",
        quitbang_handler,
        mode = { "n", "v" },
        desc = "buf[!]=> QUIT current buffer",
      },
      {
        "qd",
        bdelete_handler,
        mode = { "n", "v" },
        desc = "buf=> delete current buffer",
      },
      {
        "qD",
        bdeletebang_handler,
        mode = { "n", "v" },
        desc = "buf[!]=> DELETE current buffer",
      },
      {
        "Qq",
        quitall_handler,
        mode = { "n", "v" },
        desc = "buf=> quit all buffer",
      },
      {
        "QQ",
        quitall_handler,
        mode = { "n", "v" },
        desc = "buf=> QUIT all buffers",
      },
      {
        "QQQ",
        quitallbang_handler,
        mode = { "n", "v" },
        desc = "buf[!]=> QUIT all buffers",
      },
      {
        "<leader>b[",
        bprev_handler,
        mode = { "n", "v" },
        desc = "buf=> previous buffer",
      },
      {
        "<leader>b]",
        bnext_handler,
        mode = { "n", "v" },
        desc = "buf=> next buffer",
      },
      {
        "<C-S-Left>",
        bprev_handler,
        mode = { "n", "v", "i" },
        desc = "buf=> previous buffer",
      },
      {
        "<C-S-Right>",
        bnext_handler,
        mode = { "n", "v", "i" },
        desc = "buf=> next buffer",
      },
      {
        "<leader>bd",
        bdelete_handler,
        mode = { "n", "v" },
        desc = "buf=> delete current buffer",
      },
    },
    init = function()
      for i = 1, 9, 1 do
        local keynum = i
        mapn(
          "<leader>" .. keynum,
          string.format(
            "<CMD>lua require('nvim-smartbufs').goto_buffer(%d)<CR>",
            keynum
          ),
          { desc = string.format("buf=> goto buffer %d", keynum) }
        )
        mapn(
          "<leader>q" .. keynum,
          string.format(
            "<CMD>lua require('nvim-smartbufs').close_buffer(%d)<CR>",
            keynum
          ),
          { desc = string.format("buf=> leave buffer %d", keynum) }
        )
      end
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "BufReadPre",
    config = true,
    opts = {
      input = {
        relative = "editor",
      },
      select = {
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
        telescope = require("telescope.themes").get_ivy({
          winblend = 30,
          width = 0.70,
          prompt = "scope=> ",
          show_line = true,
          previewer = true,
          results_title = "results ",
          preview_title = "content ",
          layout_config = {
            preview_width = 0.5,
          },
        }),
      },
      border = env.borders.main,
      win_options = {
        win_blend = 10,
        wrap = true,
        list = true,
      },
    },
  },
  { "mrjones2014/smart-splits.nvim", event = "VeryLazy" },
  {
    "matbme/JABS.nvim",
    cmd = "JABSOpen",
    keys = {
      {
        "qj",
        "<CMD>JABSOpen<CR>",
        mode = { "n", "v" },
        desc = "buf=> open JABS",
      },
      {
        "<leader>j",
        "<CMD>JABSOpen<CR>",
        mode = { "n", "v" },
        desc = "buf=> open JABS",
      },
    },
    opts = {
      position = { "left", "top" },
      width = 60,
      height = 20,
      border = env.borders.main,
      preview_position = "right",
      preview = {
        width = 60,
        height = 80,
        border = "shadow",
      },
      clip_popup_size = true,
      offset = {
        top = 2,
        left = 2,
        right = 1,
        bottom = 1,
      },
      relative = "editor",
      keymap = {
        close = "q",
      },
    },
    config = true,
  },
}
