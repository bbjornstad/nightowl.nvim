local env = require("environment.ui")
local keystems = require("environment.keys").stems

local key_oil = keystems.oil
local key_nnn = keystems.nnn
local key_broot = keystems.broot
local key_files = keystems.files

local function term_broot()
  local Term = require("toggleterm.terminal").Terminal
  local broot = Term:new({ cmd = "br", hidden = true })
  local function _broot_toggle()
    broot:toggle()
  end
  -- now just map this.
  vim.keymap.set(
    { "n" },
    key_broot .. "e",
    _broot_toggle,
    { desc = "br=> tree view" }
  )
end

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
      "Gitui",
      "Xplr",
      "Vifm",
      -- "Skim",
      -- "Nnn",
      "Fff",
      "Twf",
      "Fzf",
      "Fzy",
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
      broot_conf = vim.fs.normalize("~/.config/broot/conf.hjson"),
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
        "<CMD>Broot<CR>",
        mode = "n",
        desc = "br=> right here tree",
        -- silent = true,
      },
      {
        key_broot .. "c",
        "<CMD>BrootCurrentDir<CR>",
        mode = "n",
        desc = "br=> current directory tree",
        -- silent = true,
      },
      {
        key_broot .. "w",
        "<CMD>BrootWorkingDir<CR>",
        mode = "n",
        desc = "br=> working directory tree",
        silent = true,
      },
      {
        key_broot .. "~",
        "<CMD>BrootHomeDir<CR>",
        mode = "n",
        desc = "br=> home directory tree",
        silent = true,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
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
}
