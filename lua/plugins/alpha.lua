-- vim: set ft=lua: --
local env = require("environment.ui")
local nightowl_splash = require("environment.startup").nightowl_splash
local nightowl_splash_frames =
  require("environment.startup").nightowl_splash_frames

local function ai_quote(opts)
  opts = opts or {}
end

return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "startup-nvim/startup.nvim",
    lazy = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      require("startup").setup(opts)
      vim.g.startup_bookmarks = {
        ["D"] = "~/.candy.d",
        ["C"] = "~/.config/nvim",
        ["P"] = "~/prj",
        ["N"] = "~/.notes/note-index.norg",
        ["T"] = "~/.notes/todo/junkdrawer.norg",
        ["~"] = "~",
      }
    end,
    opts = {
      theme = "nightowl_startify",
    },
    keys = {
      {
        "<Home>",
        function()
          require("startup").display(true)
        end,
        mode = "n",
        desc = "א.α => return to alpha state",
      },
      {
        "gss",
        function()
          require("startup").display(true)
        end,
        mode = "n",
        desc = "א.α => return to alpha state",
      },
      {
        "gsk",
        function()
          require("startup.utils").key_help()
        end,
        mode = "n",
        desc = "א.α => startup key mappings",
      },
    },
  },
  {
    "jovanlanik/fsplash.nvim",
    config = true,
    event = "FileType startup",
    opts = {
      lines = nightowl_splash,
      autocmds = {
        "ModeChanged",
        "CursorMoved",
        "TextChanged",
        "VimResized",
        "WinScrolled",
      },
      border = env.borders.main,
      winblend = 10,
    },
  },
  {
    "willothy/veil.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = function()
      return {
        sections = {
          -- builtin.sections.animated({
          --   nightowl_splash,
          -- }, {}),
          require("veil.builtin").sections.animated(
            nightowl_splash_frames,
            -- builtin.headers.frames_days_of_week[os.date("%A")],
            {
              hl = "@constructor",
              spacing = 2,
            }
          ),
          require("veil.builtin").sections.buttons({
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
          require("veil.builtin").sections.buttons({
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
          require("veil.builtin").sections.oldfiles(),
        },
        mappings = {},
        startup = true,
        listed = false,
      }
    end,
    event = { "VimEnter" },
    config = function(_, opts)
      -- do somme stuff
      require("veil").setup(opts)
    end,
    keys = {
      {
        "<Home>",
        "<CMD>Veil<CR>",
        mode = { "n" },
        desc = "א.α => return to alpha state",
      },
    },
  },
}
