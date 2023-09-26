-- vim: set ft=lua: --
local env = require("environment.ui")
local keystems = require("environment.keys").stems
local opt = require('environment.optional')

local key_files = keystems.files
local key_nnn = keystems.nnn
local key_bolt = keystems.bolt
local key_attempt = keystems.attempt

return {
  {
    "is0n/fm-nvim",
    enabled = opt.file_managers.fm_nvim.enable,
    cmd = {
      -- "Lazygit",
      "Joshuto",
      "Ranger",
      -- "Broot",
      -- "Gitui",
      "Xplr",
      "Vifm",
      "Skim",
      -- "Nnn",
      "Fff",
      "Twf",
      -- "Fzf",
      -- "Fzy",
      "Lf",
      "Fm",
    },
    opts = {
      edit_cmd = "edit",
      ui = {
        default = "float",
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
      mappings = {
        vert_split = "<C-v>",
        horz_split = "<C-h>",
        tabedit = "<C-t>",
        edit = "<C-e>",
        ESC = "<ESC>",
      },
    },
    config = true,
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      -- can be either "succinct" or "extended".
      vim.g.oil_extended_column_mode = false
    end,
    opts = {
      default_file_explorer = true,
      prompt_save_on_select_new_entry = true,
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
        max_width = { 100, 0.8 },
        min_width = { 32, 0.25 },
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
        ["`"] = "actions.tcd",
        ["<A-CR>"] = "actions.tcd",
        ["<BS>"] = "actions.toggle_hidden",
        ["."] = "actions.toggle_hidden",
        ["<C-BS>"] = "actions.parent",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["q"] = "actions.close",
        [".."] = "actions.parent",
        ["go."] = "actions.cd",
        ["<C-l>"] = "actions.refresh",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { callback = function()
          local extended_is_target = not (vim.b.oil_extended_column_mode or
            vim.g.oil_extended_column_mode)
          require('oil').set_columns(extended_is_target and
            env.oil.columns.extended or env.oil.columns.succinct)
          vim.b.oil_extended_column_mode = extended_is_target
        end, desc = "fm.oil=> toggle column succinct mode" },
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["g?"] = "actions.show_help",
        ["?"] = "actions.show_help",
      },
      view_options = {
        sort = {
          { "type",  "asc", },
          { "name",  "asc", },
          { "ctime", "desc" },
          { "size",  "asc", }
        }
      }
    },
    keys = {
      {
        key_files .. "oo",
        function()
          return require("oil").open_float()
        end,
        mode = { "n" },
        desc = "fm.oil=> open oil (float)",
      },
      {
        key_files .. "os",
        function()
          vim.cmd([[vsplit]])
          require('oil').open()
        end,
        mode = "n",
        desc = "fm.oil=> open oil (split)",
      },
      {
        key_files .. "O",
        function()
          require("oil").open()
        end,
        mode = { "n" },
        desc = "fm.oil=> open oil",
      },
      {
        "<leader>e",
        function()
          local root = require('lazyvim.util').get_root()
          require("oil").open(root)
        end,
        mode = { "n" },
        desc = "fm.oil=> open oil (root)",
      },
      {
        "<leader>E",
        function()
          local cwd = vim.loop.cwd() or "."
          require('oil').open(cwd)
        end,
        mode = { "n" },
        desc = "fm.oil=> open oil (cwd)",
      },
    },
  },
  {
    "luukvbaal/nnn.nvim",
    config = true,
    cmd = { "NnnExplorer", "NnnPicker" },
    opts = function(_, opts)
      opts.replace_netrw = opts.replace_netrw or "explorer"
      opts.quitcd = opts.quitcd or "tcd"
      opts.explorer = vim.tbl_deep_extend("force", {
        width = 28,
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
        { "<C-t>",  builtin.open_in_tab },       -- open file(s) in tab
        { "<C-s>",  builtin.open_in_vsplit },    -- open file(s) in split
        { "<C-v>",  builtin.open_in_vsplit },    -- open file(s) in vertical split
        { "<C-h>",  builtin.open_in_split },     -- open file(s) in vertical split
        { "<C-p>",  builtin.open_in_preview },   -- open file in preview split keeping nnn focused
        { "<C-y>",  builtin.copy_to_clipboard }, -- copy file(s) to clipboard
        { "g.",     builtin.cd_to_path },        -- cd to file directory
        { "<A-CR>", builtin.cd_to_path },        -- cd to file directory
        { "<A-:>",  builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
      }, opts.mappings or {})
      opts.auto_close = opts.auto_close or true
      opts.auto_open = vim.tbl_deep_extend("force", {
        tabpage = "picker",
        empty = "explorer",
        ft_ignore = env.ft_ignore_list,
      }, opts.auto_open or {})
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
  {
    "m-demare/attempt.nvim",
    enabled = opt.file_managers.attempt.enable,
    opts = {
      dir = vim.fs.normalize(vim.fn.stdpath("data") .. "attempt.nvim"),
      autosave = false,
      list_buffers = false, -- This will make them show on other pickers (like :Telescope buffers)
      ext_options = {
        "lua",
        "rs",
        "py",
        "cpp",
        "c",
        "ml",
        "md",
        "norg",
        "org",
        "jl",
        "hs",
        "scala",
        "sc",
        "html",
        "css",
      }, -- Options to choose from
    },
    config = function(_, opts)
      require("attempt").setup(opts)
      require("telescope").load_extension("attempt")
    end,
    keys = {
      {
        key_attempt .. "n",
        function()
          require("attempt").new_select()
        end,
        mode = "n",
        desc = "scratch=> new buffer",
      },
      {
        key_attempt .. "i",
        function()
          require("attempt").new_input_ext()
        end,
        mode = "n",
        desc = "scratch=> new buffer (custom extension)",
      },
      {
        key_attempt .. "r",
        function()
          require("attempt").run()
        end,
        mode = "n",
        desc = "scratch=> run",
      },
      {
        key_attempt .. "d",
        function()
          require("attempt").delete_buf()
        end,
        mode = "n",
        desc = "scratch=> delete buffer",
      },
      {
        key_attempt .. "c",
        function()
          require("attempt").rename_buf()
        end,
        mode = "n",
        desc = "scratch=> rename buffer",
      },
      {
        key_attempt .. "l",
        function()
          require("attempt").open_select()
        end,
        mode = "n",
        desc = "scratch=> select buffer",
      },
    },
  },
  {
    "ripxorip/bolt.nvim",
    enabled = opt.file_managers.bolt.enable,
    build = ":UpdateRemotePlugins",
    keys = {
      {
        key_bolt .. "o",
        "<CMD>Bolt<CR>",
        mode = "n",
        desc = "fm.bolt=> open project root",
      },
      {
        key_bolt .. "O",
        "<CMD>BoltCwd<CR>",
        mode = "n",
        desc = "fm.bolt=> open cwd",
      },
    },
  },
}
