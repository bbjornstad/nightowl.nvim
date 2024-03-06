-- vim: set ft=lua: --
local env = require("environment.ui")
local nightowl_splash = require("environment.alpha").nightowl_splash
local nightowl_splash_minimal =
  require("environment.alpha").nightowl_splash_minimal
local nightowl_splash_frames =
  require("environment.alpha").nightowl_splash_frames
local nightowl_splash_compact_frames =
  require("environment.alpha").nightowl_splash_compact_frames

local key_port = require("environment.keys").projport

local function alpha_state()
  vim.cmd([[Veil]])
  require("fsplash").open_window()
end

return {
  {
    "jovanlanik/fsplash.nvim",
    event = "VimEnter",
    config = true,
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
      winblend = 30,
    },
  },
  {
    "CWood-sdf/spaceport.nvim",
    opts = {
      replaceHome = true,
      projectEntry = "edit .",
      lastViewTime = "weekly",
      maxRecentFiles = 10,
      sections = {
        {
          lines = nightowl_splash_minimal,
          title = "Invisible Things are the Only Realities",
          topBuffer = 6,
        },
        "recents",
        "remaps",
        "_global_remaps",
      },
    },
    config = function(_, opts)
      require("spaceport").setup(opts)
      require("telescope").load_extension("spaceport")
    end,
    lazy = false,
    dependencies = {
      "andrewferrier/wrapping.nvim",
      "nvim-telescope/telescope.nvim",
      -- "stevearc/oil.nvim",
    },
    keys = {
      {
        key_port.projects,
        function()
          require("telescope").extensions.spaceport.projects()
        end,
        mode = "n",
        desc = "scope:| port |=> open",
      },
      {
        key_port.find,
        function()
          require("telescope").extensions.spaceport.find()
        end,
        mode = "n",
        desc = "port:| scope |=> find & add",
      },
      {
        key_port.home,
        "<CMD>Spaceport<CR>",
        mode = "n",
        desc = "start:|א port |=> init",
      },
      {
        key_port.tag,
        "<CMD>Spaceport<CR>",
        mode = "n",
        desc = "start:|א port |=> tag",
      },
      {
        "<Home>",
        "<CMD>Spaceport<CR>",
        mode = "n",
        desc = "start:|א port |=> init",
      },
    },
  },
  {
    "willothy/veil.nvim",
    lazy = false,
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = function()
      return {
        sections = {
          require("veil.builtin").sections.oldfiles({
            align = "center",
          }),
          require("veil.builtin").sections.buttons({
            {
              icon = "󰙅",
              text = "fzf::files",
              shortcut = "F",
              callback = function()
                require("fzf-lua").files()
              end,
            },
            {
              icon = "󱇚",
              text = "fzf::projects",
              shortcut = "P",
              callback = function() end,
            },
            {
              icon = "󱈇",
              text = "fzf::grep",
              shortcut = "S",
              callback = function()
                require("fzf-lua").live_grep()
              end,
            },
            {
              icon = "󱝪",
              text = "fzf::deadgrep",
              shortcut = "D",
              callback = function()
                require("fzf-lua").grep()
              end,
            },
          }, { hl = "@keyword" }),
          require("veil.builtin").sections.buttons({
            {
              icon = "󰷎",
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
                require("oil").open({ cwd = vim.fn.expand("") })
                -- vim.cmd([[tcd ~]])
                -- vim.cmd([[edit .]])
              end,
            },
            {
              icon = "󱪞",
              text = "edit::new",
              shortcut = "N",
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
              shortcut = "D",
              callback = function()
                vim.cmd([[tcd ~/.candy.d]])
                vim.cmd([[edit .]])
              end,
            },
            {
              icon = "󰺾",
              text = "edit::neovim",
              shortcut = "V",
              callback = function()
                vim.cmd([[tcd ~/.config/nvim]])
                vim.cmd([[edit .]])
              end,
            },
          }, { hl = "@string" }),
        },
        mappings = {},
        startup = true,
        listed = false,
      }
    end,
    config = function(_, opts)
      -- do somme stuff
      require("veil").setup(opts)
    end,
    keys = {
      {
        "<Home>",
        alpha_state,
        mode = { "n" },
        desc = "א:veil| α => init",
      },
    },
  },
}
