local env = require("environment.ui")
local key_bufmenu = require("environment.keys").stems.base.buffers
local key_files = require("environment.keys").stems.base.files
local mopts = require("uutils.functional").mopts

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
    init = function()
      pdel({ "n", "<leader>l" })
    end,
    keys = {
      {
        "<leader>l",
        vim.NIL,
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
      debug = false,
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
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = false,      -- position the cmdline and popupmenu together
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
    "echasnovski/mini.bufremove",
    opts = function(_, opts) end,
    config = true,
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
        "qd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        mode = "n",
        desc = "buf=> delete buffer",
      },
      {
        "qD",
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
      opts.top_down = opts.top_down or true
      opts.render = opts.render or "compact"
      opts.on_open = opts.on_open
          or function(win)
            vim.api.nvim_win_set_config(win, {
              border = env.borders.main,
            })
          end
      opts.background_colour = opts.background_colour or "Normal"
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      input = {
        relative = "win",
        border = env.borders.alt,
        start_in_insert = true,
        insert_only = true,
        win_options = {
          winblend = 20,
        },
      },
      select = {
        backend = { "fzf_lua", "fzf", "telescope", "builtin", "nui" },
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
        fzf = {
          window = {
            width = 0.5,
            height = 0.4,
          },
        },

        -- Options for nui Menu
        nui = {
          position = "50%",
          size = nil,
          relative = "editor",
          border = {
            style = env.borders.main,
          },
          buf_options = {
            swapfile = false,
            filetype = "DressingSelect",
          },
          win_options = {
            winblend = 10,
          },
          max_width = 80,
          max_height = 40,
          min_width = 40,
          min_height = 10,
        },

        -- Options for built-in selector
        builtin = {
          -- These are passed to nvim_open_win
          border = env.borders.main,
          -- 'editor' and 'win' will default to being centered
          relative = "editor",

          buf_options = {},
          win_options = {
            -- Window transparency (0-100)
            winblend = 10,
            cursorline = true,
            cursorlineopt = "both",
          },

          -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- the min_ and max_ options can be a list of mixed types.
          -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
          width = nil,
          max_width = { 140, 0.8 },
          min_width = { 40, 0.2 },
          height = nil,
          max_height = 0.9,
          min_height = { 10, 0.2 },

          -- Set to `false` to disable
          mappings = {
            ["<Esc>"] = "Close",
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
          },

          override = function(conf)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
          end,
        },
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
      width = 40,
      height = 20,
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
      relative = "cursor",
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
        function()
          require("persistence").load()
        end,
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
        function()
          require("persistence").load({ last = true })
        end,
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
        function()
          require("persistence").stop()
        end,
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
    -- ft = { "man", "vimdoc", "help" },
  },
  {
    "folke/edgy.nvim",
    init = function()
      vim.opt.splitkeep = "screen"
    end,
    opts = function()
      local opts = {
        options = {
          left = { size = 28 },
          right = { size = 30 },
          bottom = { size = 16 },
          top = { size = 16 },
        },
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
            title = "term::",
            size = { height = 0.4 },
            filter = function(buf)
              return not vim.b[buf].lazyterm_cmd
            end,
          },
          { ft = "Trouble", title = "diag::trouble" },
          { ft = "qf",      title = "edit::quickfix" },
          {
            ft = "spectre_panel",
            title = "edit::search/replace",
            size = { height = 0.4 },
          },
          {
            title = "neotest::output",
            ft = "neotest-output-panel",
            size = { height = 15 },
          },
        },
        left = {
          { title = "neotest::summary", ft = "neotest-summary" },
        },
        right = {},
        exit_when_last = true,
      }

      local Util = require("lazyvim.util")
      local function condition(condition_to, edgy_loc, copts)
        local function opts_mapper(cond, cprime)
          if Util.has(cond) then
            return mopts({}, cprime)
          end
        end
        table.insert(
          opts[edgy_loc],
          #opts[edgy_loc],
          opts_mapper(condition_to, copts)
        )
      end
      local function set_term_options(term, opts)
        local buf = vim.bo[term.bufnr]
        buf = vim.tbl_extend("force", buf, opts)
      end

      condition("toggleterm.nvim", "left", {
        title = "fm::broot",
        ft = "broot",
        size = {
          height = 0.6,
        },
        pinned = true,
        open = require('environment.utiliterm').broot({
          direction = "horizontal",
          on_open = function(term)
            set_term_options(term, { filetype = "broot", })
          end
        })
      })
      condition("symbols-outline.nvim", "right", {
        title = "symb::outline",
        ft = "Outline",
        pinned = true,
        size = {
          height = 0.5,
        },
        open = "SymbolsOutline",
      })
      condition("aerial.nvim", "right", {
        title = "symb::aerial",
        ft = "aerial",
        pinned = true,
        size = {
          height = 0.5,
        },
        open = "AerialOpen",
      })

      return opts
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        [key_bufmenu] = { name = "+buffers/quito" },
      },
    },
  },
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    opts = function(_, opts)
      local actions = require("glance").actions
      opts.height = opts.height or 16 -- Height of the window
      opts.zindex = opts.zindex or 45
      -- Or use a function to enable `detached` only when the active window is too small
      -- (default behavior)
      opts.detached = opts.detached
          or function(winid)
            return vim.api.nvim_win_get_width(winid) < 100
          end

      opts.preview_win_opts = mopts({
        -- Configure preview window
        cursorline = true,
        number = true,
        wrap = true,
      }, opts.preview_win_opts)
      opts.border = mopts({
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = "🮩",
        bottom_char = "🮨",
      }, opts.border)
      opts.list = mopts({
        position = "right", -- Position of the list window 'left'|'right'
        width = 0.33,       -- 33% width relative to the active window, min 0.1, max 0.5
      }, opts.list)
      opts.theme = mopts(
        {                -- This feature might not work properly in nvim-0.7.2
          enable = true, -- Will generate colors for the plugin based on your current colorscheme
          mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
        }, opts.theme)
      opts.mappings = mopts({
        list = {
          ["j"] = actions.next,     -- Bring the cursor to the next item in the list
          ["k"] = actions.previous, -- Bring the cursor to the previous item in the list
          ["<Down>"] = actions.next,
          ["<Up>"] = actions.previous,
          ["<Tab>"] = actions.next_location,       -- Bring the cursor to the next location skipping groups in the list
          ["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
          ["<C-u>"] = actions.preview_scroll_win(5),
          ["<C-d>"] = actions.preview_scroll_win(-5),
          ["v"] = actions.jump_vsplit,
          ["s"] = actions.jump_split,
          ["t"] = actions.jump_tab,
          ["<CR>"] = actions.jump,
          ["o"] = actions.jump,
          ["l"] = actions.open_fold,
          ["h"] = actions.close_fold,
          ["<leader>l"] = actions.enter_win("preview"), -- Focus preview window
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<C-q>"] = actions.quickfix,
          -- ['<Esc>'] = false -- disable a mapping
        },
        preview = {
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<Tab>"] = actions.next_location,
          ["<S-Tab>"] = actions.previous_location,
          ["<leader>l"] = actions.enter_win("list"), -- Focus list window
        },
      }, opts.mapping)
      opts.hooks = mopts({}, opts.hooks)
      opts.folds = mopts({
        fold_closed = "",
        fold_open = "",
        folded = true, -- Automatically fold list on startup
      }, opts.folds)
      opts.indent_lines = mopts({
        enable = true,
        icon = "│",
      }, opts.indent_lines)
      opts.winbar = mopts({
        enable = true, -- Available strating from nvim-0.8+
      }, opts.winbar)
    end,
    keys = {
      {
        "glr",
        "<CMD>Glance references<CR>",
        mode = "n",
        desc = "glance=> references",
      },
      {
        "gld",
        "<CMD>Glance definitions<CR>",
        mode = "n",
        desc = "glance=> definitions",
      },
      {
        "glt",
        "<CMD>Glance type_definitions<CR>",
        mode = "n",
        desc = "glance=> type definitions",
      },
      {
        "gli",
        "<CMD>Glance implementations<CR>",
        mode = "n",
        desc = "glance=> implementations",
      },
    },
  },
  {
    "stevearc/stickybuf.nvim",
    event = "BufWinEnter",
    cmd = { "PinBuffer", "PinBuftype", "PinFiletype", "Unpin" },
    opts = {
      get_auto_pin = function(bufnr)
        -- do any required filtration prior to using default settings.
        local bufft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if
            vim.list_contains({
              "Outline",
              "nnn",
            }, bufft)
        then
          return "filetype"
        end
        return require("stickybuf").should_auto_pin(bufnr)
      end,
    },
  },
  {
    "anuvyklack/windows.nvim",
    event = "BufWinEnter",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function(_, opts)
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup(opts)
    end,
    opts = {
      autowidth = {
        enable = true,
        winwidth = 5,
        filetype = {
          help = 2,
        },
      },
      ignore = {
        buftype = { "quickfix" },
        filetype = env.ft_ignore_list,
      },
      animation = {
        enable = true,
        duration = 300,
        fps = 60,
        easing = "in_out_sine",
      },
    },
  },
  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      window = {
        open = "smart",
        diff = "tab_vsplit",
      },
      one_per = {
        wezterm = false,
      },
    },
    config = function(_, opts)
      require("flatten").setup(opts)
    end,
  },
  {
    "tiagovla/scope.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(_, opts)
      require("scope").setup(opts)
      require("telescope").load_extension("scope")
    end,
    opts = {},
    keys = {
      {
        key_files .. "B",
        "<CMD>Telescope scope buffers<CR>",
        mode = "n",
        desc = "scope.buf=> view buffers",
      },
    },
  },
}
