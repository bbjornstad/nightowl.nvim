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
        desc = "buf:| die => current",
      },
      {
        key_buffer.force_delete,
        function()
          require("mini.bufremove").delete(0, true)
        end,
        mode = "n",
        desc = "buf:| die! |=> delete",
      },
      {
        key_buffer.wipeout,
        function()
          require("mini.bufremove").wipeout(0, false)
        end,
        mode = "n",
        desc = "buf:| DIE |=> wipeout",
      },
      {
        key_buffer.force_wipeout,
        function()
          require("mini.bufremove").wipeout(0, true)
        end,
        mode = "n",
        desc = "buf:| DIE! |=> wipeout",
      },
      {
        key_buffer.delete_others,
        function()
          local bs = vim.cmd([[buffers]])
          vim.tbl_map(function(b)
            require("mini.bufremove").delete(b, false)
          end, bs)
        end,
        mode = "n",
        desc = "buf:| die |=> others",
      },
      {
        key_buffer.force_delete_others,
        function()
          local bs = vim.cmd([[buffers]])
          vim.tbl_map(function(b)
            require("mini.bufremove").delete(b, true)
          end, bs)
        end,
        mode = "n",
        desc = "buf:| die! |=> others",
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
    "stevearc/stickybuf.nvim",
    enabled = false,
    event = "BufWinEnter",
    cmd = { "PinBuffer", "PinBuftype", "PinFiletype", "Unpin" },
    opts = {
      -- get_auto_pin = function(bufnr)
      --   -- do any required filtration prior to using default settings.
      --   local bufft = vim.api.nvim_buf_get_option(bufnr, "filetype")
      --   if vim.list_contains({ "lazy" }, bufft) then
      --     return "filetype"
      --   end
      --   return require("stickybuf").should_auto_pin(bufnr)
      -- end,
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
        hybridnumber = true,
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
        desc = "win:| focus |=> toggle max",
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
        desc = "ui:| focus |=> toggle",
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
    "ghillb/cybu.nvim",
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
        max_win_height = 12,
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
    config = function(_, opts)
      require("early-retirement").setup(opts)
    end,
    opts = {
      -- if a buffer has been inactive for this many minutes, close it
      retirementAgeMins = 30,

      -- filetypes to ignore
      ignoredFiletypes = vim.list_extend(
        { "norg", "org", "md", "oil", "spaceport", "scissors" },
        env.ft_ignore_list
      ),

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
      ignoreUnloadedBufs = true,

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
    event = "BufWinEnter",
  },
  {
    "yutkat/confirm-quit.nvim",
    event = "CmdlineEnter",
    opts = { overwrite_q_command = true },
    config = function(_, opts)
      require("confirm-quit").setup(opts)
    end,
  },
  {
    "Lilja/zellij.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function(_, opts)
      require("zellij").setup(opts)
    end,
    opts = {
      path = "zellij",
      replaceVimWindowNavigationKeybinds = true,
      vimTmuxNavigatorKeybinds = true,
      debug = false,
    },
    cmd = {
      "ZellijNavigateLeft",
      "ZellijNavigateRight",
      "ZellijNavigateUp",
      "ZellijNavigateDown",
      "ZellijNewPane",
      "ZellijNewTab",
      "ZellijRenamePane",
      "ZellijRenameTab",
    },
  },
}
