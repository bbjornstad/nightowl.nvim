local env = require("environment.ui")
local nightowl_splash = require("environment.veil").nightowl_splash
local nightowl_splash_frames =
  require("environment.veil").nightowl_splash_frames

return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "willothy/veil.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "jovanlanik/fsplash.nvim",
        config = true,
        event = { "FileType veil" },
        opts = {
          lines = nightowl_splash,
          autocmds = {
            -- "ModeChanged",
            -- "CursorMoved",
            -- "TextChanged",
            -- "VimResized",
            -- "WinScrolled",
          },
          border = env.borders.main,
          winblend = 10,
        },
      },
    },
    opts = function()
      local opts = {}
      local builtin = require("veil.builtin")
      opts.sections = {
        -- builtin.sections.animated({
        --   nightowl_splash,
        -- }, {}),
        builtin.sections.animated(
          nightowl_splash_frames,
          -- builtin.headers.frames_days_of_week[os.date("%A")],
          {
            hl = "@constructor",
            spacing = 2,
          }
        ),
        builtin.sections.buttons({
          {
            icon = "",
            text = "fzf::files",
            shortcut = "f",
            callback = function()
              require("fzf-lua").files()
            end,
          },
          {
            icon = "󱇚",
            text = "fzf::projects",
            shortcut = "p",
            callback = function() end,
          },
          {
            icon = "󱈇",
            text = "fzf::grep",
            shortcut = "g",
            callback = function()
              require("fzf-lua").live_grep()
            end,
          },
          {
            icon = "󱝪",
            text = "fzf::deadgrep",
            shortcut = "G",
            callback = function()
              require("fzf-lua").grep()
            end,
          },
        }, { hl = "@keyword" }),
        builtin.sections.buttons({
          {
            icon = "󰷉",
            text = "edit::cwd",
            shortcut = ".",
            callback = function()
              vim.cmd([[edit .]])
            end,
          },
          {
            icon = "󰷉",
            text = "edit::home",
            shortcut = "~",
            callback = function()
              vim.cmd([[tcd ~]])
              vim.cmd([[edit .]])
            end,
          },
          {
            icon = "󱪞",
            text = "edit::new",
            shortcut = "n",
            callback = function()
              vim.ui.input({ prompt = "new file name:" }, function(input)
                local cmdstr = ([[edit %s]]):format(input)
                vim.cmd(cmdstr)
              end)
            end,
          },
          {
            icon = "󱥳",
            text = "edit::.candy.d",
            shortcut = "d",
            callback = function()
              vim.cmd([[tcd ~/.candy.d]])
              vim.cmd([[edit .]])
            end,
          },
          {
            icon = "󰺾",
            text = "edit::neovim",
            shortcut = "v",
            callback = function()
              vim.cmd([[tcd ~/.config/nvim]])
              vim.cmd([[edit .]])
            end,
          },
        }, { hl = "@string" }),
        builtin.sections.oldfiles(),
      }
      opts.mappings = {}
      opts.startup = true
      opts.listed = false
      return opts
    end,
    event = { "VimEnter" },
    config = function(_, opts)
      -- do somme stuff
      require("veil").setup(opts)
    end,
    keys = {
      -- {
      --   "<Home>",
      --   "<CMD>Veil<CR>",
      --   mode = { "n" },
      --   desc = "א.α => return to alpha state",
      -- },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = true,
    event = "VimEnter",
    config = true,
    opts = {
      theme = "hyper",
      shortcut_type = "letter",
      hide = { statusline = false, tabline = false, winbar = true },
      preview = {
        file_path = true,
        file_height = true,
        file_width = true,
      },
      change_to_vcs_root = true,
      config = {
        footer = nightowl_splash,
        week_header = {
          enable = true,
        },
        project = {
          enable = true,
          limit = 10,
          action = function()
            require("fzf-lua").files()
          end,
        },
        mru = { enable = true, limit = 10 },
        shortcut = {
          {
            icon = "󱛕",
            desc = " ⌊ .candy.d ⌋  ",
            group = "@label",
            key = "d",
            action = function()
              vim.cmd(([[edit %s]]):format(os.getenv("DOTCANDYD_USER_HOME")))
            end,
          },
          {
            icon = "󱉮",
            desc = " ⌊ cwd ⌋  ",
            group = "@label",
            key = "~",
            action = function()
              vim.cmd([[edit .]])
            end,
          },
          {
            icon = "󰱽",
            desc = " ⌊ fzf::files ⌋  ",
            group = "@label",
            key = "z",
            action = function()
              require("fzf-lua").files({ cwd = "." })
            end,
          },
          {
            icon = "󰱽",
            desc = " ⌊ fzf::live_grep ⌋  ",
            group = "@label",
            key = "g",
            action = function()
              require("fzf-lua").live_grep({ cwd = "." })
            end,
          },
          {
            icon = "󰱽",
            desc = " ⌊ new file ⌋  ",
            group = "@label",
            key = "n",
            action = function()
              vim.ui.input({ prompt = "file name:" }, function(input)
                local cmdstr = ([[edit %s]]).format(input)
                vim.cmd(cmdstr)
              end)
            end,
          },
        },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "ibhagwan/fzf-lua",
      -- {
      --   "jovanlanik/fsplash.nvim",
      --   config = true,
      --   event = { "FileType dashboard" },
      --   opts = {
      --     lines = nightowl_splash,
      --     autocmds = {
      --       -- "ModeChanged",
      --       -- "CursorMoved",
      --       -- "TextChanged",
      --       -- "VimResized",
      --       -- "WinScrolled",
      --     },
      --     border = env.borders.main,
      --     winblend = 10,
      --   },
      -- },
    },
    keys = {
      {
        "<Home>",
        "<CMD>Dashboard<CR>",
        mode = { "n" },
        desc = "א.α => return to alpha state",
      },
    },
  },
}
