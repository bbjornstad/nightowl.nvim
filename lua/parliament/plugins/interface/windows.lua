---@diagnostic disable: inject-field
local env = require("environment.ui")
local kenv = require("environment.keys")
local opt = require("environment.optional")
local key_win = kenv.window
local key_view = kenv.view
local key_buffer = kenv.buffer
local key_ui = kenv.ui
local mopts = require("funsak.table").mopts
local has = require("funsak.lazy").has
local toggle = require("funsak.toggle")

local function winsep_disable_ft()
  local colorful_winsep = require("colorful-winsep")
  local win_n = require("colorful-winsep.utils").calculate_number_windows()
  if win_n == 2 then
    local win_id = vim.fn.win_getid(vim.fn.winnr("h"))
    local filetype = vim.api.nvim_buf_get_option(
      vim.api.nvim_win_get_buf(win_id or 0),
      "filetype"
    )
    if vim.tbl_contains({ "NvimTree", "nnn", "broot", "netrw" }, filetype) then
      colorful_winsep.NvimSeparatorDel()
    end
  end
end

return {
  {
    "echasnovski/mini.bufremove",
    opts = function(_, opts) end,
    config = true,
    keys = {
      {
        key_buffer.delete,
        function()
          require("mini.bufremove").delete(0, false)
        end,
        mode = "n",
        desc = "buf:| => delete",
      },
      {
        key_buffer.force_delete,
        function()
          require("mini.bufremove").delete(0, true)
        end,
        mode = "n",
        desc = "buf:| [!] |=> delete",
      },
      {
        key_buffer.wipeout,
        function()
          require("mini.bufremove").wipeout(0, false)
        end,
        mode = "n",
        desc = "buf:| |=> wipeout",
      },
      {
        key_buffer.force_wipeout,
        function()
          require("mini.bufremove").wipeout(0, true)
        end,
        mode = "n",
        desc = "buf:| [!] |=> wipeout",
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      input = {
        relative = "cursor",
        border = env.borders.alt,
        start_in_insert = true,
        insert_only = true,
        win_options = { winblend = 20 },
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
          layout_config = { preview_width = 0.5 },
        }),
        fzf = { window = { width = 0.5, height = 0.4 } },

        -- Options for nui Menu
        nui = {
          position = "50%",
          size = nil,
          relative = "win",
          border = { style = env.borders.main },
          buf_options = {
            swapfile = false,
            filetype = "DressingSelect",
          },
          win_options = { winblend = 30 },
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
            winblend = 30,
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
      win_options = { win_blend = 30, wrap = true, list = true },
    },
  },
  {
    "matbme/JABS.nvim",
    cmd = "JABSOpen",
    keys = {
      {
        key_buffer.jabs,
        "<CMD>JABSOpen<CR>",
        mode = "n",
        desc = "buf:| jabs |=> win:float",
      },
    },
    opts = {
      position = { "left", "top" },
      width = 72,
      height = 24,
      border = env.borders.main,
      preview_position = "right",
      preview = { width = 60, height = 40, border = env.borders.main },
      clip_popup_size = true,
      offset = { top = 2, left = 2, right = 1, bottom = 1 },
      relative = "win",
      keymap = { close = "d", h_split = "h", v_split = "s", preview = "p" },
      use_devicons = true,
      sort_mru = true,
    },
    config = true,
  },
  {
    "anuvyklack/help-vsplit.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("help-vsplit").setup(opts)
    end,
    opts = {
      always = true,
      side = "right",
      buftype = { "help" },
      filetype = { "man" },
    },
  },
  {
    "folke/edgy.nvim",
    init = function()
      vim.opt.splitkeep = "screen"
    end,
    keys = {
      {
        key_view.edgy.toggle,
        function()
          require("edgy").toggle()
        end,
        mode = "n",
        desc = "win:| edgy |=> toggle",
      },
      {
        key_view.edgy.select,
        function()
          require("edgy").select()
        end,
        mode = "n",
        desc = "win:| edgy |=> select",
      },
    },
    opts = function()
      local op = {
        options = {
          left = { size = 28 },
          right = { size = 30 },
          bottom = { size = 16 },
          top = { size = 16 },
        },
        bottom = {
          {
            ft = "toggleterm",
            title = "term.toggle::",
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
            title = "term.lazy::",
            size = { height = 0.4 },
            filter = function(buf)
              return not vim.b[buf].lazyterm_cmd
            end,
          },
          { ft = "Trouble", title = "diag::trouble" },
          { ft = "qf", title = "edit::quickfix" },
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
        left = { { title = "neotest::summary", ft = "neotest-summary" } },
        right = {},
        exit_when_last = true,
      }

      if has("outline.nvim") then
        op.left = vim.list_extend(op.left, {
          title = "symb::outline",
          ft = "Outline",
          size = { height = 0.5 },
        })
      end

      --- inserts the contents of the `copts` argument into the target edgy
      --- window if it satisfies the given condition evaluation.
      ---@param condition_to any expression to evaluate as a boolean condition.
      ---@param edgy_loc "bottom" | "left" | "right" window edge location to
      ---insert into.
      ---@param values table the values that are to be inserted as a new
      ---component.
      local function condition(condition_to, edgy_loc, values)
        local function opts_mapper(cond, cprime)
          if has(cond) or has(cond .. ".nvim") then
            return mopts({}, cprime)
          end
        end
        table.insert(
          op[edgy_loc],
          #op[edgy_loc],
          opts_mapper(condition_to, values)
        )
      end
      local function set_term_options(term, opts)
        local buf = vim.bo[term.bufnr]
        buf = vim.tbl_extend("force", buf, opts)
      end

      condition("toggleterm.nvim", "left", {
        title = "fm::broot",
        ft = "broot",
        size = { height = 0.6 },
        pinned = true,
        open = require("environment.utiliterm").broot({
          direction = "horizontal",
          on_open = function(term)
            set_term_options(term, { filetype = "broot" })
          end,
        }),
      })
      -- condition("aerial.nvim", "left", {
      --   title = "symb::aerial",
      --   ft = "aerial",
      --   size = {
      --     height = 0.5,
      --   },
      -- })
    end,
  },
  {
    "stevearc/stickybuf.nvim",
    event = "BufWinEnter",
    cmd = { "PinBuffer", "PinBuftype", "PinFiletype", "Unpin" },
    opts = {
      get_auto_pin = function(bufnr)
        -- do any required filtration prior to using default settings.
        local bufft = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if vim.list_contains({ "nnn" }, bufft) then
          return "filetype"
        end
        return require("stickybuf").should_auto_pin(bufnr)
      end,
    },
  },
  {
    "nvim-focus/focus.nvim",
    version = false,
    event = "BufWinEnter",
    config = function(_, opts)
      local ignore_buftypes = { "nofile", "prompt", "popup" }
      local ignore_filetypes = env.ft_ignore_list
      require("focus").setup(opts)
      local grp =
        vim.api.nvim_create_augroup("FtDisableFocus", { clear = true })
      vim.api.nvim_create_autocmd({ "WinEnter" }, {
        group = grp,
        callback = function(ev)
          if vim.tbl_contains(ignore_buftypes, vim.bo[ev.buf].buftype) then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
        desc = "Disable focus autoresizer for special buffer types",
      })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = grp,
        callback = function(ev)
          if vim.tbl_contains(ignore_filetypes, vim.bo[ev.buf].filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = "Disable focus autoresizer for special filetypes",
      })
    end,
    opts = {
      enable = true,
      autoresize = { minwidth = 12, minheight = 18, height_quickfix = 16 },
      split = { bufnew = true },
      ui = {
        number = false,
        hybridnumber = false,
        absolutenumber_unfocussed = false,
        cursorline = false,
        winhighlight = false,
        cursorcolumn = false,
        colorcolumn = { enable = false, list = "+1" },
        signcolumn = false,
      },
    },
    keys = {
      {
        key_win.focus.maximize,
        "<CMD>FocusMaxOrEqual<CR>",
        mode = "n",
        desc = "win::| focus |=> toggle max",
      },
      {
        key_win.focus.split.cycle,
        "<CMD>FocusSplitCycle<CR>",
        mode = "n",
        desc = "win:| focus |=> split cycle",
      },
      {
        key_win.focus.split.direction,
        require("parliament.utils.window").focus_split_helper,
        expr = true,
        remap = true,
        mode = "n",
        desc = "win:| focus |=> split towards",
      },
      {
        key_ui.focus,
        toggle.focus,
        mode = "n",
        desc = "win:| focus |=> toggle",
      },
    },
  },
  {
    "willothy/flatten.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      window = { open = "smart", diff = "tab_vsplit" },
      one_per = { wezterm = false },
    },
    config = function(_, opts)
      require("flatten").setup(opts)
    end,
  },
  {
    "tiagovla/scope.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    config = function(_, opts)
      require("scope").setup(opts)
      require("telescope").load_extension("scope")
    end,
    opts = {},
    keys = {
      {
        kenv.buffer.telescope.scope,
        "<CMD>Telescope scope buffers<CR>",
        mode = "n",
        desc = "scope:| buf |=> view buffers",
      },
    },
  },
  {
    "jyscao/ventana.nvim",
    enabled = opt.windowing.ventana,
    cmd = { "VentanaTranspose", "VentanaShift", "VentanaShiftMaintainLinear" },
    keys = {
      {
        key_win.ventana.transpose,
        "<CMD>VentanaTranspose<CR>",
        mode = "n",
        desc = "win:| vent |=> transpose",
      },
      {
        key_win.ventana.shift,
        "<CMD>VentanaShift<CR>",
        mode = "n",
        desc = "win:| vent |=> shift",
      },
      {
        key_win.ventana.linear_shift,
        "<CMD>VentanaShiftMaintainLinear<CR>",
        mode = "n",
        desc = "win:| vent |=> linear shift",
      },
    },
  },
  {
    "ghillb/cybu.nvim",
    enabled = opt.windowing.cybu,
    event = "VeryLazy",
    branch = "main",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      local mapx = vim.keymap.set
      require("cybu").setup(opts)
      mapx(
        "n",
        "<C-S-h>",
        "<Plug>(CybuPrev)",
        { desc = "win:| cybu |=> previous" }
      )
      mapx("n", "<C-S-l>", "<Plug>(CybuNext)", { desc = "win:| cybu |=> next" })
      mapx(
        "i",
        "<C-S-h>",
        "<C-o><Plug>(CybuPrev)",
        { desc = "win:| cybu |=> previous" }
      )
      mapx(
        "i",
        "<C-S-l>",
        "<C-o><Plug>(CybuNext)",
        { desc = "win:| cybu |=> next" }
      )
      mapx("n", "[b", "<Plug>(CybuPrev)", { desc = "win:| cybu |=> previous" })
      mapx("n", "]b", "<Plug>(CybuNext)", { desc = "win:| cybu |=> next" })
      mapx(
        { "n", "v" },
        "<c-s-tab>",
        "<plug>(CybuLastusedPrev)",
        { desc = "win:| cybu |=> [mru] previous" }
      )
      mapx(
        { "n", "v" },
        "<c-tab>",
        "<plug>(CybuLastusedNext)",
        { desc = "win:| cybu |=> [mru] next" }
      )
    end,
    opts = {
      position = {
        relative_to = "win",
        anchor = "topleft",
        vertical_offset = 12,
        horizontal_offset = 16,
        max_win_height = 8,
        max_win_width = 0.4,
      },
      style = {
        path = "relative",
        path_abbreviation = "shortened",
        border = env.borders.alt,
        separator = " :: ",
        prefix = "󱃺",
        padding = 6,
        hide_buffer_id = false,
        devicons = { enabled = true, colored = true, truncate = true },
      },
      behavior = {
        mode = {
          default = { switch = "immediate", view = "rolling" },
          last_used = { switch = "on_close", view = "paging" },
          auto = { view = "rolling" },
        },
      },
      display_time = 1600,
      filter = { unlisted = true },
    },
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    enabled = opt.windowing.colorful_winsep,
    event = "BufWinEnter",
    config = function(_, opts)
      require("colorful-winsep").setup(opts)
      winsep_disable_ft()
    end,
    opts = {
      interval = 30,
      no_exec_files = env.ft_ignore_list,
      symbols = { "═", "║", "╔", "╗", "╚", "╝" },
    },
  },
  {
    "chrisgrieser/nvim-early-retirement",
    enabled = opt.windowing.early_retirement,
    config = function(_, opts)
      require("early-retirement").setup(opts)
    end,
    opts = {
      -- if a buffer has been inactive for this many minutes, close it
      retirementAgeMins = 30,

      -- filetypes to ignore
      ignoredFiletypes = env.ft_ignore_list,

      -- ignore files matching this lua pattern; empty string disables this setting
      ignoreFilenamePattern = "",

      -- will not close the alternate file
      ignoreAltFile = true,

      -- minimum number of open buffers for auto-closing to become active. E.g.,
      -- by setting this to 4, no auto-closing will take place when you have 3
      -- or fewer open buffers. Note that this plugin never closes the currently
      -- active buffer, so a number < 2 will effectively disable this setting.
      minimumBufferNum = 4,

      -- will ignore buffers with unsaved changes. If false, the buffers will
      -- automatically be written and then closed.
      ignoreUnsavedChangesBufs = true,

      -- ignore non-empty buftypes, for example terminal buffers
      ignoreSpecialBuftypes = true,

      -- ignore visible buffers ("a" in `:buffers`). Buffers that are open in
      -- a window or in a tab are considered visible by vim.
      ignoreVisibleBufs = true,

      -- ignore unloaded buffers. Session-management plugin often add buffers
      -- to the buffer list without loading them.
      ignoreUnloadedBufs = false,

      -- Show notification on closing. Works with nvim-notify or noice.nvim
      notificationOnAutoClose = true,

      -- when a file is deleted, for example via an external program, delete the
      -- associated buffer as well
      deleteBufferWhenFileDeleted = true,
    },
    event = "VeryLazy",
  },
  {
    "axkirillov/hbac.nvim",
    opts = {
      autoclose = true,
      threshold = 5,
      close_command = function(bufnr)
        require("mini.bufremove").delete(bufnr)
      end,
    },
    config = function(_, opts)
      require("hbac").setup(opts)
      require("telescope").load_extension("hbac")
    end,
    event = { "VeryLazy" },
    cmd = { "Hbac" },
    keys = {
      {
        key_buffer.hbac.pin.toggle,
        function()
          require("hbac").toggle_pin()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
      {
        key_buffer.hbac.pin.all,
        function()
          require("hbac").pin_all()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
      {
        key_buffer.hbac.pin.unpin_all,
        function()
          require("hbac").toggle_pin()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
      {
        key_buffer.hbac.pin.close_unpinned,
        function()
          require("hbac").toggle_pin()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
      {
        key_buffer.hbac.telescope,
        function()
          require("hbac").toggle_pin()
        end,
        mode = "n",
        desc = "buf:| pin |=> toggle",
      },
    },
  },
  {
    "kwkarlwang/bufresize.nvim",
    opts = {
      register = {
        keys = {
          { "n", "<C-w><", "<C-w><", { noremap = true, silent = true } },
          { "n", "<C-w>>", "<C-w>>", { silent = true, noremap = true } },
          { "n", "<C-w>+", "<C-w>+", { silent = true, noremap = true } },
          { "n", "<C-w>-", "<C-w>-", { silent = true, noremap = true } },
          { "n", "<C-w>_", "<C-w>_", { silent = true, noremap = true } },
          { "n", "<C-w>=", "<C-w>=", { silent = true, noremap = true } },
          { "n", "<C-w>|", "<C-w>|", { silent = true, noremap = true } },
          {
            "",
            "<LeftRelease>",
            "<LeftRelease>",
            { silent = true, noremap = true },
          },
          {
            "i",
            "<LeftRelease>",
            "<LeftRelease><C-o>",
            { silent = true, noremap = true },
          },
        },
      },
    },
    config = function(_, opts)
      require("bufresize").setup(opts)
    end,
    enabled = true,
    event = "BufWinEnter",
  },
  {
    "michaelPotter/accordian.nvim",
    opts = {},
    enabled = true,
    config = function(_, opts)
      require("accordian").setup()
    end,
    event = "VeryLazy",
    keys = {
      {
        key_win.accordian,
        "<CMD>Accordian<CR>",
        mode = "n",
        desc = "win:| accordian |=> toggle",
      },
    },
  },
  {
    "anuvyklack/windows.nvim",
    enabled = false,
    -- enabled = opt.prefer.focus_windows == "windows",
    dependencies = {
      "anuvyklack/middleclass",
    },
    opts = {
      autowidth = {
        enable = false,
        winwidth = 1.2,
      },
      ignore = {
        buftype = { "quickfix", "nofile", "prompt", "popup" },
        filetype = env.ft_ignore_list,
      },
      animation = {
        enable = false,
      },
    },
    config = function(_, opts)
      vim.o.winwidth = 16
      vim.o.winminwidth = 12
      vim.o.equalalways = false
      require("windows").setup(opts)
    end,
    event = "BufWinEnter",
  },
}
