local env = require("environment.ui")
local mapn = require("environment.keys").map({ "n" })
local mapx = vim.keymap.set

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
            height = "auto",
          },
          -- put it on top of everything else that could exist below (we picked
          -- 1200 because it was larger than the largest present zindex
          -- definition for any other component)
          zindex = 1200,
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
          position = { row = 20, col = "50%" },
          size = { width = 80, height = "auto" },
          -- once again, put it on top of everything else that could exist below.
          -- 1200 rationale still holds here too.
          zindex = 1200,
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
            text = {},
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
          filter = {
            event = "msg_show",
            kind = "progress",
            find = "checking document",
          },
          opts = { skip = true },
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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "outline" },
        group = vim.api.nvim_create_augroup("enable_focus_for_docsymbols", {}),
        callback = require("focus").focus_enable_window,
      })
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
    init = function()
      mapx(
        { "n", "v" },
        "<leader>qq",
        require("nvim-smartbufs").close_current_buffer,
        { desc = "buf=> close current buffer" }
      )
      mapx(
        { "n", "v" },
        "<leader>qQ",
        "<CMD>qa<CR>",
        { desc = "buf=> close all buffers" }
      )
      mapx(
        { "n", "v" },
        "<leader>QQ",
        "<CMD>qa!<CR>",
        { desc = "buf=> close all buffers immediately" }
      )
      mapx(
        { "n", "v" },
        "<leader>b[",
        require("nvim-smartbufs").goto_prev_buffer,
        { desc = "buf=> previous buffer" }
      )
      mapx(
        { "n", "v" },
        "<leader>b]",
        require("nvim-smartbufs").goto_next_buffer,
        { desc = "buf=> next buffer" }
      )
      mapx(
        { "n", "v", "i" },
        "<C-S-Left>",
        require("nvim-smartbufs").goto_prev_buffer,
        { desc = "buf=> previous buffer" }
      )
      mapx(
        { "n", "v", "i" },
        "<C-S-Right>",
        require("nvim-smartbufs").goto_next_buffer,
        { desc = "buf=> next buffer" }
      )
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
      mapx(
        { "n", "v" },
        "<leader>bq",
        require("nvim-smartbufs").close_current_buffer,
        { desc = "buf=> close current buffer" }
      )
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
          winblend = 15,
          width = 0.70,
          prompt = "telescope=>",
          show_line = true,
          previewer = true,
          results_title = "results",
          preview_title = "content",
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
}
