local env = require("environment.ui")
local keystems = require("environment.keys").stems
local wk_family = require("environment.keys").wk_family_inject

local key_oil = keystems.oil
local key_nnn = keystems.nnn
local key_files = keystems.files

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    module = false,
  },
  {
    "is0n/fm-nvim",
    enabled = true,
    event = "VeryLazy",
    cmd = {
      "Neomutt",
      "Lazygit",
      "Joshuto",
      "Ranger",
      "Broot",
      "Gitui",
      "Xplr",
      "Vifm",
      "Skim",
      "Nnn",
      "Fff",
      "Twf",
      "Fzf",
      "Fzy",
      "Lf",
      "Fm",
      "TaskWarriorTUI",
    },
    opts = {
      edit_cmd = "edit",
      ui = {
        default = "split",
        float = {
          border = env.borders.main,
          float_hl = "Normal",
          border_hl = "FloatBorder",
          blend = 20,
          height = 0.6,
          width = 0.6,
        },
        split = {
          direction = "topleft",
          size = 32,
        },
      },
    },
    config = true,
    keys = {
      {
        key_files .. "e",
        "<CMD>Broot<CR>",
        mode = "n",
        desc = "br=> open broot explorer",
      },
      {
        key_files .. "E",
        "<CMD>Broot<CR>",
        mode = "n",
        desc = "br=> open broot explorer (float)",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      columns = {
        "icon",
        "type",
        "permissions",
        "birthtime",
        "atime",
        "mtime",
        "size",
      },
      delete_to_trash = true,
      float = {
        padding = 4,
        border = env.borders.main,
      },
      preview = {
        max_width = 0.8,
        min_width = { 40, 0.4 },
        border = env.borders.main,
        win_options = {
          winblend = 20,
        },
      },
      progress = {
        max_width = 0.45,
        min_width = { 40, 0.2 },
        border = env.borders.main,
        minimized_border = env.borders.main,
        win_options = {
          winblend = 20,
        },
      },
      keymaps = {
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["<BS>"] = "actions.toggle_hidden",
        ["<C-BS>"] = "actions.parent",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["q"] = "actions.close",
        [".."] = "actions.parent",
        ["g."] = "actions.cd",
        ["<C-l>"] = "actions.refresh",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = false,
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["g?"] = "actions.show_help",
        ["?"] = "actions.show_help",
      },
    },
    keys = {
      {
        key_oil .. "o",
        function()
          return require("oil").open_float()
        end,
        mode = { "n" },
        desc = "oil=> open oil (float)",
      },
      {
        key_oil .. "O",
        function()
          return require("oil").open()
        end,
        mode = { "n" },
        desc = "oil=> open oil (not float)",
      },
      {
        key_oil .. "q",
        function()
          return require("oil").close()
        end,
        mode = { "n" },
        desc = "oil=> close oil",
      },
      {
        "<leader>e",
        function()
          return require("oil").open_float()
        end,
        mode = { "n" },
        desc = "oil=> float oil",
      },
      {
        "<leader>E",
        function()
          return require("oil").open()
        end,
        mode = { "n" },
        desc = "oil=> open oil",
      },
    },
  },
  {
    "luukvbaal/nnn.nvim",
    config = true,
    cmd = { "NnnExplorer", "NnnPicker" },
    opts = function(_, opts)
      opts.explorer = vim.tbl_deep_extend("force", {
        width = 32,
        side = "topleft",
        session = "shared",
        tabs = true,
        fullscreen = false,
      }, opts.explorer or {})
      opts.picker = vim.tbl_deep_extend("force", {
        style = {
          width = 0.4,
          height = 0.6,
          border = env.borders.main,
        },
      }, opts.picker or {})
      local builtin = require("nnn").builtin
      opts.mappings = vim.tbl_deep_extend("force", {
        { "g..", builtin.cd_to_path }, -- open file(s) in tab
        { "<C-t>", builtin.open_in_tab }, -- open file(s) in tab
        { "<C-s>", builtin.open_in_vsplit }, -- open file(s) in split
        { "<C-v>", builtin.open_in_vsplit }, -- open file(s) in vertical split
        { "<C-h>", builtin.open_in_split }, -- open file(s) in vertical split
        { "<C-p>", builtin.open_in_preview }, -- open file in preview split keeping nnn focused
        { "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
        { "g.", builtin.cd_to_path }, -- cd to file directory
        { "<A-:>", builtin.populate_cmdline }, -- populate cmdline (:) with file(s)
      }, opts.mappings or {})
    end,
    keys = {
      {
        key_files .. "nE",
        "<CMD>NnnExplorer<CR>",
        mode = "n",
        desc = "fm.nnn=> explorer mode",
      },
      {
        key_files .. "ne",
        "<CMD>NnnExplorer %:p<CR>",
        mode = "n",
        desc = "fm.nnn=> explorer mode",
      },
      {
        key_files .. "np",
        "<CMD>NnnPicker<CR>",
        mode = { "n" },
        desc = "fm.nnn=> picker mode",
      },
      {
        key_nnn .. "N",
        "<CMD>NnnPicker<CR>",
        mode = { "n" },
        desc = "fm.nnn=> picker mode",
      },
      {
        key_nnn .. "n",
        "<CMD>NnnExplorer<CR>",
        mode = { "n" },
        desc = "fm.nnn=> explorer mode",
      },
    },
  },
  wk_family("fm.nnn", "<leader>nn", { triggers_nowait = { key_nnn } }),
}
