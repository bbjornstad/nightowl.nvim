-- vim: set ft=lua: --
local env = require("environment.ui")
local opt = require("environment.optional")

local kenv = require("environment.keys")
local key_fm = kenv.fm
local key_shortcut = kenv.shortcut

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    module = false,
  },
  {
    "lstwn/broot.vim",
    enabled = opt.file_managers.broot,
    init = function()
      vim.g.broot_default_conf_path = (
        vim.env.XDG_CONFIG_HOME .. "/broot/conf.hjson"
      )
      vim.g.broot_replace_netrw = 0
    end,
    keys = {
      {
        key_fm.broot.working_dir,
        "<CMD>BrootWorkingDir<CR>",
        mode = "n",
        desc = "fm.broot=> working directory",
      },
      {
        key_fm.broot.current_dir,
        "<CMD>BrootCurrentDir<CR>",
        mode = "n",
        desc = "fm.broot=> current directory",
      },
    },
  },
  {
    "is0n/fm-nvim",
    enabled = opt.file_managers.fm_nvim,
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
        edit = "<C-m>",
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
      vim.g.oil_extended_column_mode = env.oil.init_columns == "extended"
    end,
    opts = {
      default_file_explorer = true,
      prompt_save_on_select_new_entry = true,
      columns = env.oil.init_columns == "succinct" and env.oil.columns.succinct
        or env.oil.columns.extended,
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
        ["<A-`>"] = "actions.tcd",
        ["<A-CR>"] = "actions.tcd",
        ["<BS>"] = "actions.toggle_hidden",
        ["."] = "actions.toggle_hidden",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["q"] = "actions.close",
        [key_fm.oil:close()] = "actions.close",
        [".."] = "actions.parent",
        ["<C-r>"] = "actions.refresh",
        ["<C-P>"] = "actions.preview",
        ["<C-C>"] = {
          callback = function()
            local extended_is_target = vim.b.oil_extended_column_mode
              or vim.g.oil_extended_column_mode

            require("oil").set_columns(
              extended_is_target and env.oil.columns.extended
                or env.oil.columns.succinct
            )
            vim.b.oil_extended_column_mode = extended_is_target
          end,
          desc = "fm.oil=> toggle succinct columns",
        },
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["?"] = "actions.show_help",
        ["<S-CR>"] = "actions.select",
        ["<CR>"] = false,
      },
      view_options = {
        sort = {
          { "type", "asc" },
          { "name", "asc" },
          { "ctime", "desc" },
          { "size", "asc" },
        },
      },
    },
    keys = {
      {
        key_fm.oil.open_float,
        function()
          return require("oil").open_float()
        end,
        mode = { "n" },
        desc = "fm.oil=> open (float)",
      },
      {
        key_fm.oil.split,
        function()
          vim.cmd([[vsplit]])
          require("oil").open()
        end,
        mode = "n",
        desc = "fm.oil=> open (split)",
      },
      {
        key_fm.oil.open,
        function()
          require("oil").open()
        end,
        mode = { "n" },
        desc = "fm.oil=> open",
      },
      {
        key_shortcut.fm.explore.explore,
        function()
          require("oil").open_float()
        end,
        mode = { "n" },
        desc = "fm.oil=> open",
      },
      {
        key_shortcut.fm.explore.split,
        function()
          -- local cwd = vim.loop.cwd() or "."
          -- vim.cmd([[vsplit]])
          require("oil").open()
        end,
        mode = { "n" },
        desc = "fm.oil=> open oil (split)",
      },
    },
  },
  {
    "luukvbaal/nnn.nvim",
    config = true,
    cmd = { "NnnExplorer", "NnnPicker" },
    opts = function(_, opts)
      opts.replace_netrw = opts.replace_netrw or nil
      opts.quitcd = opts.quitcd or "tcd"
      opts.explorer = vim.tbl_deep_extend("force", {
        width = 20,
        side = "topleft",
        session = "shared",
        tabs = true,
        fullscreen = false,
      }, opts.explorer or {})
      opts.picker = vim.tbl_deep_extend("force", {
        style = {
          width = 0.2,
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
        key_fm.nnn.explorer,
        "<CMD>NnnExplorer<CR>",
        mode = "n",
        desc = "fm.nnn=> explorer mode",
      },
      {
        key_fm.nnn.explorer_here,
        "<CMD>NnnExplorer %:p<CR>",
        mode = "n",
        desc = "fm.nnn=> explorer mode",
      },
      {
        key_fm.nnn.picker,
        "<CMD>NnnPicker<CR>",
        mode = { "n" },
        desc = "fm.nnn=> picker mode",
      },
      {
        key_shortcut.fm.nnn.picker,
        "<CMD>NnnPicker<CR>",
        mode = { "n" },
        desc = "fm.nnn=> picker mode",
      },
      {
        key_shortcut.fm.nnn.explorer,
        "<CMD>NnnExplorer<CR>",
        mode = { "n" },
        desc = "fm.nnn=> explorer mode",
      },
    },
  },
  {
    "m-demare/attempt.nvim",
    enabled = opt.file_managers.attempt,
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
        key_fm.attempt.new_select,
        function()
          require("attempt").new_select()
        end,
        mode = "n",
        desc = "scratch=> new buffer",
      },
      {
        key_fm.attempt.new_input_ext,
        function()
          require("attempt").new_input_ext()
        end,
        mode = "n",
        desc = "scratch=> new buffer (custom extension)",
      },
      {
        key_fm.attempt.run,
        function()
          require("attempt").run()
        end,
        mode = "n",
        desc = "scratch=> run",
      },
      {
        key_fm.attempt.delete,
        function()
          require("attempt").delete_buf()
        end,
        mode = "n",
        desc = "scratch=> delete buffer",
      },
      {
        key_fm.attempt.rename,
        function()
          require("attempt").rename_buf()
        end,
        mode = "n",
        desc = "scratch=> rename buffer",
      },
      {
        key_fm.attempt.open_select,
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
    enabled = opt.file_managers.bolt,
    build = ":UpdateRemotePlugins",
    keys = {
      {
        key_fm.bolt.open_root,
        "<CMD>Bolt<CR>",
        mode = "n",
        desc = "fm.bolt=> open project root",
      },
      {
        key_fm.bolt.open_cwd,
        "<CMD>BoltCwd<CR>",
        mode = "n",
        desc = "fm.bolt=> open cwd",
      },
    },
  },
  {
    "gaborvecsei/memento.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    config = false,
    init = function()
      vim.g.memento_history = 50
      vim.g.memento_shorten_path = true
      vim.g.memento_window_width = 80
      vim.g.memento_window_height = 16
    end,
    keys = {
      {
        key_fm.memento.toggle,
        function()
          require("memento").toggle()
        end,
        mode = "n",
        desc = "mem=> recently closed files",
      },
      {
        key_fm.memento.clear,
        function()
          require("memento").clear_history()
        end,
        mode = "n",
        desc = "mem=> clear closed file history",
      },
    },
  },
  {
    "dzfrias/arena.nvim",
    opts = {
      max_items = 12,
      always_context = { "mod.rs", "init.lua" },
      ignore_current = true,
      per_project = true,
      window = {
        width = 32,
        height = 12,
        border = env.borders.main,
      },
      algorithm = {
        recency_factor = 0.5,
        frequency_factor = 1,
      },
    },
    config = function(_, opts)
      require("arena").setup(opts)
    end,
    event = "BufWinEnter",
    keys = {
      {
        key_fm.arena.toggle,
        function()
          require("arena").toggle()
        end,
        mode = "n",
        desc = "fm.arena=> toggle",
      },
      {
        key_fm.arena.open,
        function()
          require("arena").open()
        end,
        mode = "n",
        desc = "fm.arena=> open",
      },
      {
        key_fm.arena.close,
        function()
          require("arena").close()
        end,
        mode = "n",
        desc = "fm.arena=> close",
      },
    },
  },
}
