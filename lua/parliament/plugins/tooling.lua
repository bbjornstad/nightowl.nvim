-- vim: set ft=lua sts=2 ts=2 sw=2 et:
local env = require("environment.ui")
local kenv = require("environment.keys")
local key_macro = kenv.macro
local mapx = vim.keymap.set
local key_screenshot = kenv.editor.silicon
local key_wrap = kenv.editor.wrapping
local key_view = kenv.view

return {
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
    config = function(_, opts)
      require("bqf").setup(opts)
    end,
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
    "0oAstro/silicon.lua",
    enabled = true,
    build = "./install.sh",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      output = vim.fn.expand("%:p")
        .. "_code_[year][month][day]-[hour][minute][second].png",
      font = "Monaspace Argon=16",
      theme = "auto",
      bgColor = vim.g.terminal_color_5,
      shadowBlurRadius = 0.4,
      shadowOffsetX = 4,
      shadowOffsetY = 2,
      shadowColor = "#66666B",
      roundCorner = false,
      windowControls = true,
      linePad = 2,
      padHoriz = 60,
      padVert = 100,
      gobble = false,
      debug = true,
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("silicon").setup(opts)
    end,
    keys = {
      {
        key_screenshot.save,
        function()
          vim.ui.input({ prompt = "󰞡  save screenshot to: " }, function(sel)
            if not sel then
              return
            end
            vim.cmd(
              ([[Silicon %s]]):format(vim.fs.normalize(vim.fn.expand(sel)))
            )
          end)
        end,
        mode = "v",
        desc = "shot:| screen |=> save to",
      },
      {
        key_screenshot.yank,
        "<CMD>Silicon<CR>",
        mode = "v",
        desc = "shot:| screen |=> yank",
      },
    },
    init = function()
      local acmd =
        require("funsak.autocmd").autocmdr("NightowlSiliconRefresh", true)
      acmd({ "ColorScheme" }, {
        callback = function(ev)
          require("silicon.utils").build_tmTheme()
          require("silicon.utils").reload_silicon_cache({ async = true })
        end,
      })
    end,
  },
  {
    "andrewferrier/wrapping.nvim",
    config = function(_, opts)
      require("wrapping").setup(opts)
    end,
    opts = function(_, opts)
      opts.create_commands = true
      opts.create_keymaps = false
      opts.notify_on_switch = true
      opts.auto_set_mode_filetype_allow_list = vim.list_extend(
        opts.auto_set_mode_filetype_allowlist or {},
        { "spaceport", "notify", "noice" }
      )
      opts.softener = {
        spaceport = false,
        notify = false,
        noice = false,
      }
    end,
    keys = {
      {
        key_wrap.mode.hard,
        function()
          require("wrapping").hard_wrap_mode()
        end,
        mode = "n",
        desc = "wrap:| mode |=> hard",
      },
      {
        key_wrap.mode.soft,
        function()
          require("wrapping").soft_wrap_mode()
        end,
        mode = "n",
        desc = "wrap:| mode |=> soft",
      },
      {
        key_wrap.mode.toggle,
        function()
          require("wrapping").toggle_wrap_mode()
        end,
        mode = "n",
        desc = "wrap:| mode |=> toggle",
      },
      {
        key_wrap.log,
        "<CMD>WrappingOpenLog<CR>",
        mode = "n",
        desc = "wrap:| log |=> open",
      },
    },
  },
  {
    "GeekMasher/securitree.nvim",
    enabled = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
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
        desc = "securitree:| panel |=> toggle",
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    opts = {
      open_browser_app = "xdg-open", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
      open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
      handlers = {
        plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
        github = true, -- open github issues
        brewfile = true, -- open Homebrew formulaes and casks
        package_json = true, -- open dependencies from package.json
        search = true, -- search the web/selection on the web if nothing else is found
      },
      handler_options = {
        search_engine = "google", -- you can select between google, bing, duckduckgo, and ecosia
      },
    },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1
    end,
    config = function(_, opts)
      require("gx").setup(opts)
    end,
    keys = {
      {
        "gx",
        "<CMD>Browse<CR>",
        mode = { "n", "x" },
        desc = "open:| link |=> open ",
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
