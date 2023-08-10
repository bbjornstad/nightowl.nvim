local env = require("environment.ui")
local mapx = vim.keymap.set
local key_bufmenu = require("environment.keys").stems.base.buffers
local wk_family = require("environment.keys").wk_family_inject
local ignore_buftypes = require("environment.ui").ft_ignore_list

local function pdel(mode, keys, opts)
  local ok, res = pcall(vim.keymap.del, mode, keys, opts)
  if not ok then
    return nil
  end
  return res
end

return {
  {
    "williamboman/mason.nvim",
    opts = { ui = { border = env.borders.main } },
  },
  {
    "folke/lazy.nvim",
    opts = function(_, opts)
      pdel({ "n" }, "<leader>l")
      opts.dev = vim.tbl_deep_extend("force", {
        path = "~/prj/nvim-dev",
        patterns = {},
        fallback = true,
      })
    end,
    keys = {
      {
        "<leader>l",
        vim.NIL,
        mode = "n",
      },
      {
        "<leader>L",
        "<CMD>Lazy<CR>",
        mode = "n",
        desc = "lazy=> home",
      },
    },
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
        minwidth = 32,
        width = 36,
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
          ":lua require('focus').split_command('"
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
      vim.api.nvim_create_autocmd("WinEnter", {
        group = vim.api.nvim_create_augroup("FocusDisable", { clear = true }),
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.b.focus_disable = true
          end
        end,
        desc = "Disable focus autoresize for BufTypes",
      })
    end,
  },
  {
    "echasnovski/mini.bufremove",
    opts = function(_, opts)
      pdel({ "n" }, "<leader>bd")
      pdel({ "n" }, "<leader>bD")
    end,
    keys = {
      {
        "<leader>bd",
        false,
      },
      {
        "<leader>bD",
        false,
      },
      {
        "qbd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        mode = "n",
        desc = "buf=> delete buffer",
      },
      {
        "qbD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        mode = "n",
        desc = "buf=> delete[!] buffer",
      },
    },
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
  {
    "matbme/JABS.nvim",
    cmd = "JABSOpen",
    keys = {
      {
        "qbj",
        "<CMD>JABSOpen<CR>",
        mode = "n",
        desc = "buf=> open JABS",
      },
      {
        "qj",
        "<CMD>JABSOpen<CR>",
        mode = "n",
        desc = "buf=> open JABS",
      },
    },
    opts = {
      position = { "right", "top" },
      width = 80,
      height = 36,
      border = env.borders.main,
      preview_position = "left",
      preview = {
        width = 80,
        height = 36,
        border = env.borders.main,
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
        close = "d",
        h_split = "h",
        v_split = "s",
        preview = "p",
      },
      use_devicons = true,
    },
    config = true,
  },
  {
    "folke/persistence.nvim",
    opts = function(_, opts)
      pdel({ "n" }, "q")
      pdel({ "n" }, "<leader>qs")
      pdel({ "n" }, "<leader>ql")
      pdel({ "n" }, "<leader>qd")
    end,
    keys = {
      {
        "q",
        false,
        mode = "n",
      },
      {
        "<leader>qs",
        false,
        mode = "n",
      },
      {
        "qss",
        [[<CMD>lua require('persistence').load()<CR>]],
        mode = "n",
        desc = "sesh=> load session",
      },
      {
        "<leader>ql",
        false,
        mode = "n",
      },
      {
        "qsl",
        [[<CMD>lua require('persistence').load({ last = true })<CR>]],
        mode = "n",
        desc = "sesh=> load last session",
      },
      {
        "<leader>qd",
        false,
        mode = "n",
      },
      {
        "qst",
        [[<CMD>lua require('persistence').stop()<CR>]],
        mode = "n",
        desc = "sesh=> stop session",
      },
    },
  },
  {
    "anuvyklack/help-vsplit.nvim",
    config = function(_, opts)
      require("help-vsplit").setup(opts)
    end,
    opts = {
      always = false,
      side = "right",
      buftype = { "help" },
      filetype = { "man" },
    },
    event = "VeryLazy",
  },
  {
    "folke/edgy.nvim",
    opts = function()
      local opts = {
        bottom = {
          {
            ft = "toggleterm",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "noice",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "lazyterm",
            title = "LazyTerm",
            size = { height = 0.4 },
            filter = function(buf)
              return not vim.b[buf].lazyterm_cmd
            end,
          },
          "Trouble",
          { ft = "qf", title = "QuickFix" },
          { ft = "spectre_panel", size = { height = 0.4 } },
          {
            title = "Neotest Output",
            ft = "neotest-output-panel",
            size = { height = 15 },
          },
        },
        left = {
          {
            title = "nnn",
            ft = "nnn",
            size = {
              height = 0.33,
            },
            pinned = true,
            open = "NnnExplorer",
          },
          { title = "Neotest Summary", ft = "neotest-summary" },
        },
      }

      local Util = require("lazyvim.util")
      if Util.has("aerial.nvim") then
        table.insert(opts.left, #opts.left, {
          title = "aerial",
          ft = "aerial",
          pinned = true,
          open = "AerialOpen left",
        })
      end
      if Util.has("symbols-outline.nvim") then
        table.insert(opts.left, #opts.left, {
          title = "Outline",
          ft = "Outline",
          pinned = true,
          open = "SymbolsOutline",
        })
      end
      return opts
    end,
  },
  wk_family("buffer menu", key_bufmenu, {
    triggers_nowait = {
      key_bufmenu,
    },
  }),
}
