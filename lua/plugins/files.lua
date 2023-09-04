-- vim: set ft=lua: --
local env = require("environment.ui")
local keystems = require("environment.keys").stems

local key_oil = keystems.oil
local key_nnn = keystems.nnn
local key_broot = keystems.broot
local key_files = keystems.files
local key_attempt = keystems.attempt
local key_traveller = keystems.traveller

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    module = false,
  },
  {
    "is0n/fm-nvim",
    enabled = true,
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
      broot_conf = vim.fs.normalize(
        vim.fn.expand("~/.config/broot/conf.hjson")
      ),
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
    "lstwn/broot.vim",
    cmd = { "Broot", "BrootCurrentDir", "BrootWorkingDir", "BrootHomeDir" },
    config = function(_, opts)
      -- TODO: Determine if we need to do anything in config here.
    end,
    opts = {},
    init = function()
      vim.g.broot_default_conf_path =
        vim.fs.normalize("~/.config/broot/conf.hjson")
      -- vim.g.broot_replace_netrw = 1
      -- vim.g.loaded_netrwPlugin = 1
      -- vim.g.broot_command = "br"
    end,
    keys = {
      {
        key_broot .. "e",
        "<CMD>Broot vsplit<CR>",
        mode = "n",
        desc = "br=> right here tree",
        -- silent = true,
      },
      {
        key_broot .. "c",
        "<CMD>BrootCurrentDir vsplit<CR>",
        mode = "n",
        desc = "br=> current directory tree",
        -- silent = true,
      },
      {
        key_broot .. "w",
        "<CMD>BrootWorkingDir vsplit<CR>",
        mode = "n",
        desc = "br=> working directory tree",
        -- silent = true,
      },
      {
        key_broot .. "~",
        "<CMD>BrootHomeDir vsplit<CR>",
        mode = "n",
        desc = "br=> home directory tree",
        -- silent = true,
      },
    },
  },
  -- {
  --   "bbjornstad/broot.nvim",
  --   dev = true,
  --   config = false,
  --   cmd = "Broot",
  --   keys = {
  --     {
  --       key_broot .. "e",
  --       "<CMD>Broot<CR>",
  --       mode = "n",
  --       desc = "br=> right here tree",
  --       -- silent = true,
  --     },
  --   },
  -- },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = false,
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
          require("oil").open()
        end,
        mode = { "n" },
        desc = "oil=> open oil (not float)",
      },
      {
        key_oil .. "q",
        function()
          require("oil").close()
        end,
        mode = { "n" },
        desc = "oil=> close oil",
      },
      {
        "<leader>e",
        function()
          local cwd = vim.b.netrw_curdir
          require("oil").open_float(cwd)
        end,
        mode = { "n" },
        desc = "oil=> float oil",
      },
      {
        "<leader>E",
        function()
          local cwd = vim.b.netrw_curdir
          require("oil").open(cwd)
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
        { "<C-t>", builtin.open_in_tab }, -- open file(s) in tab
        { "<C-s>", builtin.open_in_vsplit }, -- open file(s) in split
        { "<C-v>", builtin.open_in_vsplit }, -- open file(s) in vertical split
        { "<C-h>", builtin.open_in_split }, -- open file(s) in vertical split
        { "<C-p>", builtin.open_in_preview }, -- open file in preview split keeping nnn focused
        { "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
        { "g.", builtin.cd_to_path }, -- cd to file directory
        { "<A-CR>", builtin.cd_to_path }, -- cd to file directory
        { "<A-:>", builtin.populate_cmdline }, -- populate cmdline (:) with file(s)
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
    "Norlock/nvim-traveller",
    event = "VeryLazy",
    enabled = false,
    config = function(_, opts)
      require("nvim-traveller").setup(opts)
    end,
    opts = {
      show_hidden = true,
      mappings = {
        directories_tab = "<Tab>",
        directories_delete = "<C-d>",
      },
    },
    keys = {
      {
        key_traveller .. "o",
        function()
          require("nvim-traveller").open_navigation()
        end,
        mode = "n",
        desc = "fm.travel=> open",
      },
      {
        key_traveller .. "d",
        function()
          require("nvim-traveller").last_directories_search()
        end,
        mode = "n",
        desc = "fm.travel=> last directories",
      },
      {
        key_traveller .. "t",
        function()
          require("nvim-traveller").open_terminal()
        end,
        mode = "n",
        desc = "fm.travel=> terminal mode",
      },
    },
  },
}
