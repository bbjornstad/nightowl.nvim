-- vim: set ft=lua sts=2 ts=2 sw=2 et:
local env = require("environment.ui")
local kenv = require("environment.keys")
local key_term = kenv.term
local key_macro = kenv.macro
local mapx = vim.keymap.set
local key_treesj = kenv.tool.splitjoin
local key_code_shot = kenv.editor.code_shot
local key_replace = kenv.replace
local key_notes = kenv.editor.notes
local key_wrap = kenv.editor.wrapping
local key_view = kenv.view

local utiliterm = require("environment.utiliterm")

return {
  {
    "smjonas/inc-rename.nvim",
    cmd = { "IncRename" },
    dependencies = {
      {
        "folke/noice.nvim",
        optional = true,
        opts = {
          presets = {
            inc_rename = true,
          },
        },
      },
    },
    config = function(_, opts)
      require("inc-rename").setup(opts)
    end,
    opts = {
      preview_empty_name = false,
      input_buffer_type = "dressing",
    },
    keys = {
      {
        key_replace.inc_rename,
        "<CMD>IncRename<CR>",
        mode = "n",
        desc = "search=> incremental",
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = {
      open_mapping = "<F1>",
      float_opts = {
        border = env.borders.main,
        winblend = 10,
      },
      insert_mappings = true,
      terminal_mappings = true,
      autochdir = true,
      direction = "float",
      size = function(term)
        if term.direction == "horizontal" then
          return 0.25 * vim.api.nvim_win_get_height(0)
        elseif term.direction == "vertical" then
          return 0.25 * vim.api.nvim_win_get_width(0)
        elseif term.direction == "float" then
          return 85
        end
      end,
      shading_factor = 4,
      winbar = {
        enabled = false,
      },
    },
    keys = {
      {
        key_term.layout.vertical,
        function()
          require("toggleterm").setup({ direction = "vertical" })
        end,
        mode = { "n", "t" },
        desc = "term=> toggle vertical layout",
      },
      {
        key_term.layout.horizontal,
        function()
          require("toggleterm").setup({ direction = "horizontal" })
        end,
        mode = { "n", "t" },
        desc = "term=> toggle horizontal layout",
      },
      {
        key_term.layout.float,
        function()
          require("toggleterm").setup({ direction = "float" })
        end,
        mode = { "n", "t" },
        desc = "term=> toggle float layout",
      },
      {
        key_term.layout.tabbed,
        function()
          require("toggleterm").setup({ direction = "tabbed" })
        end,
        mode = { "n", "t" },
        desc = "term=> toggle tabbed layout",
      },
      -- custom terminal mappings go here.
      {
        key_term.utiliterm.btop,
        utiliterm.btop(),
        mode = "n",
        desc = "term.mon=> btop",
      },
      {
        key_term.utiliterm.sysz,
        utiliterm.sysz(),
        mode = "n",
        desc = "term.mon=> sysz",
      },
      {
        key_term.utiliterm.weechat,
        utiliterm.weechat(),
        mode = "n",
        desc = "term.mon=> weechat",
      },
      {
        key_term.utiliterm.broot,
        utiliterm.broot(),
        mode = "n",
        desc = "term.fm=> broot",
      },
    },
    init = function()
      vim.g.hidden = true
      local function set_terminal_keymaps(bufnr)
        local opts = { buffer = bufnr or 0 }
        mapx(
          "t",
          "<leader><esc>",
          [[<C-\><C-n>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> escape",
          }, opts)
        )
        mapx(
          "t",
          "<C-S-h>",
          [[<Cmd>wincmd h<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> go to left window",
          }, opts)
        )
        mapx(
          "t",
          "<C-S-j>",
          [[<Cmd>wincmd j<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> go to below window",
          }, opts)
        )
        mapx(
          "t",
          "<C-S-k>",
          [[<Cmd>wincmd k<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> go to above window",
          }, opts)
        )
        mapx(
          "t",
          "<C-S-l>",
          [[<Cmd>wincmd l<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> go to right window",
          }, opts)
        )
        mapx(
          "t",
          "<C-w>",
          [[<C-\><C-n><C-w>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> window management",
          }, opts)
        )
        mapx(
          "t",
          [[<C-\><C-q>]],
          "<CMD>quit<CR>",
          vim.tbl_deep_extend("force", {
            remap = false,
            nowait = true,
            desc = "term=> close terminal",
          }, opts)
        )
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = { "term://*toggleterm#*" },
        callback = function(ev)
          set_terminal_keymaps(ev.buf)
        end,
        group = vim.api.nvim_create_augroup("terminal_open_keymappings", {}),
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true, -- highly recommended enable
      preview = {
        win_height = 16,
        win_vheight = 2,
        delay_syntax = 80,
        border = env.borders.main,
        show_title = false,
        should_preview_cb = function(bufnr, winid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if (fsize > 100 * 1024) or bufname:match("^fugitive://") then
            -- skip file size greater than 100k
            ret = false
          end
          return ret
        end,
      },
      -- make `drop` and `tab drop` to become preferred
      func_map = {
        drop = "o",
        openc = "O",
        split = "<C-s>",
        tabdrop = "<C-t>",
        -- set to empty string to disable
        tabc = "",
        ptogglemode = "z,",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
    config = true,
  },
  {
    "Wansmer/treesj",
    keys = {
      {
        key_treesj.toggle,
        function()
          require("treesj").toggle()
        end,
        mode = "n",
        desc = "treesj=> toggle fancy splitjoin",
      },
      {
        key_treesj.join,
        function()
          require("treesj").join()
        end,
        mode = "n",
        desc = "treesj=> join with splitjoin",
      },
      {
        key_treesj.split,
        function()
          require("treesj").split()
        end,
        mode = "n",
        desc = "treesj=> split with splitjoin",
      },
    },
    config = function(_, opts)
      require("treesj").setup(opts)
    end,
    opts = {
      -- Use default keymaps
      -- (<space>m - toggle, <space>j - join, <space>s - split)
      use_default_keymaps = false,

      -- Node with syntax error will not be formatted
      check_syntax_error = true,

      -- If line after join will be longer than max value,
      -- node will not be formatted
      max_join_length = 120,

      -- hold|start|end:
      -- hold - cursor follows the node/place on which it was called
      -- start - cursor jumps to the first symbol of the node being formatted
      -- end - cursor jumps to the last symbol of the node being formatted
      cursor_behavior = "hold",

      -- Notify about possible problems or not
      notify = true,

      -- Use `dot` for repeat action
      dot_repeat = true,
    },
  },
  {
    "cshuaimin/ssr.nvim",
    opts = {
      border = env.borders.main,
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
    config = function(_, opts)
      require("ssr").setup(opts)
    end,
    keys = {
      {
        key_replace.structural,
        function()
          require("ssr").open()
        end,
        mode = "n",
        desc = "rp.struct=> structural search replace",
      },
    },
  },
  {
    "AckslD/muren.nvim",
    config = function(_, opts)
      require("muren").setup(opts)
    end,
    cmd = {
      "MurenToggle",
      "MurenOpen",
      "MurenClose",
      "MurenFresh",
      "MurenUnique",
    },
    opts = {
      cwd = true,
    },
    keys = {
      {
        -- "go substitute/replace"
        key_replace.muren.toggle,
        "<CMD>MurenToggle<CR>",
        mode = "n",
        desc = "rp.muren=> toggle replacer",
      },
      {
        key_replace.muren.open,
        "<CMD>MurenOpen<CR>",
        mode = "n",
        desc = "rp.muren=> open [!] replacer",
      },
      {
        key_replace.muren.close,
        "<CMD>MurenClose<CR>",
        mode = "n",
        desc = "rp.muren=> close [!] replacer",
      },
      {
        key_replace.muren.fresh,
        "<CMD>MurenFresh<CR>",
        mode = "n",
        desc = "rp.muren=> fresh replacer",
      },
      {
        key_replace.muren.unique,
        "<CMD>MurenUnique<CR>",
        mode = "n",
        desc = "rp.muren=> unique replacer",
      },
    },
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      start_of_line = false,
      pad_comment_parts = true,
      ignore_blank_line = false,
    },
    version = false,
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    version = false,
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
    opts = {
      respect_selection_type = true,
      search_method = "cover",
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
  {
    "echasnovski/mini.align",
    event = "VeryLazy",
    version = false,
    opts = {
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    },
  },
  {
    "chrisgrieser/nvim-recorder",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-notify",
    },
    config = function(_, opts)
      require("recorder").setup(opts)
    end,
    opts = {
      slots = { "a", "b" },
      clear = true,
      dapSharedKeymaps = true,
      mapping = {
        startStopRecording = key_macro.record,
        playMacro = key_macro.play,
        switchSlot = key_macro.switch,
        editMacro = key_macro.edit,
        yankMacro = key_macro.yank,
        add_breakpoint = "<C-q><C-b>",
      },
    },
  },
  {
    "VidocqH/auto-indent.nvim",
    event = "VeryLazy",
    opts = {
      lightmode = true,
      indentexpr = nil,
      ignore_filetype = env.ft_ignore_list,
    },
    config = function(_, opts)
      require("auto-indent").setup(opts)
    end,
  },
  {
    "monaqa/dial.nvim",
    config = function(_, opts)
      -- do anything to register new dial targets here. this is somewhat
      -- confusing setup.
    end,
    keys = {
      {
        "<C-y>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        mode = "n",
        desc = "dial=> increment",
      },
      {
        "<C-S-y>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        mode = "n",
        desc = "dial=> decrement",
      },
      {
        "g<C-y>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        mode = "n",
        desc = "dial=> gincrement",
      },
      {
        "g<C-S-y>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        mode = "n",
        desc = "dial=> gdecrement",
      },
      {
        "<C-y>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        mode = "v",
        desc = "dial=> increment",
      },
      {
        "<C-S-y>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        mode = "v",
        desc = "dial=> decrement",
      },
      {
        "g<C-y>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        mode = "v",
        desc = "dial=> gincrement",
      },
      {
        "g<C-S-y>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        mode = "v",
        desc = "dial=> gdecrement",
      },
    },
  },
  {
    "EdmondTabaku/eureka",
    config = function(_, opts)
      require("eureka").setup(opts)
    end,
    opts = {
      default_notes = {
        "${ project }: ${ project_desc }",
      },
      close_key = "qq",
    },
    keys = {
      {
        key_notes.eureka,
        function()
          require("eureka").show_notes()
        end,
        mode = "n",
        desc = "note.eureka=> open",
      },
    },
  },
  {
    "krivahtoo/silicon.nvim",
    enabled = false,
    build = "./install.sh",
    opts = {
      output = {
        clipboard = true,
        path = ".",
        format = vim.fn.expand("%:p")
          .. "_code_[year][month][day]-[hour][minute][second].png",
      },
      font = "Monaspace Argon=16",
      theme = "Dracula",
      background = "#15152A",
      shadow = {
        blur = 0.4,
        offset_x = 4,
        offset_y = 2,
      },
    },
    config = function(_, opts)
      require("silicon").setup(opts)
    end,
  },
  {
    "andrewferrier/wrapping.nvim",
    config = function(_, opts)
      require("wrapping").setup(opts)
    end,
    opts = {
      create_commands = true,
      create_keymaps = false,
      notify_on_switch = true,
    },
    keys = {
      {
        key_wrap.mode.hard,
        function()
          require("wrapping").hard_wrap_mode()
        end,
        mode = "n",
        desc = "wrap=> hard mode",
      },
      {
        key_wrap.mode.soft,
        function()
          require("wrapping").soft_wrap_mode()
        end,
        mode = "n",
        desc = "wrap=> soft mode",
      },
      {
        key_wrap.mode.toggle,
        function()
          require("wrapping").toggle_wrap_mode()
        end,
        mode = "n",
        desc = "wrap=> toggle mode",
      },
      {
        key_wrap.log,
        "<CMD>WrappingOpenLog<CR>",
        mode = "n",
        desc = "wrap=> log",
      },
    },
  },
  {
    "GeekMasher/securitree.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
      -- optional
      "nvim-treesitter/playground",
    },
    config = function()
      require("securitree").setup({
        autocmd = false,
        autopanel = false,
      })
    end,
    event = "VeryLazy",
    keys = {
      {
        key_view.securitree.toggle,
        "<CMD>SecuriTreeToggle<CR>",
        mode = "n",
        desc = "securitree=> toggle",
      },
    },
  },
}
