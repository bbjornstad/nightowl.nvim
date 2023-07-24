local env = require("environment.ui")
local keystems = require("environment.keys").stems

local key_oil = keystems.oil

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
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
        max_width = 0.7,
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
        ["<C-.>"] = "actions.cd",
        ["`"] = false,
        ["<C-t>"] = false,
        ["<BS>"] = "actions.parent",
        ["-"] = "actions.parent",
        ["q"] = "actions.close",
      },
    },
    keys = {
      {
        key_oil .. "o",
        function()
          return require("oil").open_float()
        end,
        mode = { "n", "v" },
        desc = "oil=> open oil (float)",
      },
      {
        key_oil .. "O",
        function()
          return require("oil").open()
        end,
        mode = { "n", "v" },
        desc = "oil=> open oil (not float)",
      },
      {
        key_oil .. "q",
        function()
          return require("oil").close()
        end,
        mode = { "n", "v" },
        desc = "oil=> close oil",
      },
      {
        "<leader>e",
        function()
          return require("oil").open_float()
        end,
        mode = { "n", "v" },
        desc = "oil=> float oil",
      },
    },
  },
  {
    "junegunn/fzf",
    event = "VeryLazy",
    dependencies = { "junegunn/fzf.vim" },
    build = "make",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fzf" },
        group = vim.api.nvim_create_augroup("fzf quit on q", {}),
        callback = function()
          vim.keymap.set(
            "n",
            "q",
            "<CMD>quit<CR>",
            { buffer = true, desc = "quit", remap = false, nowait = true }
          )
        end,
      })
    end,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    event = { "VeryLazy" },
  },
}
