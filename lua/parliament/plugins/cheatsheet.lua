local env = require("environment.ui")
local key_help = require("environment.keys").help

return {
  {
    "sudormrfbin/cheatsheet.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      require("cheatsheet").setup(opts)
      require("telescope").load_extension("cheatsheet")
    end,
    opts = {
      bundled_cheatsheets = true,
      bundled_plugin_cheatsheets = true,
      include_only_installed_plugins = true,
    },
    keys = {
      {
        key_help.cheatsheet,
        function()
          require("telescope").extensions.cheatsheet.cheatsheet()
        end,
        mode = { "n" },
        desc = "cheat=> cheatsheet interface",
      },
    },
  },
  {
    "RishabhRD/nvim-cheat.sh",
    cmd = { "Cheat", "CheatWithoutComments" },
    keys = {
      {
        key_help.cheatsh.search,
        function()
          vim.ui.input({
            prompt = "cheat.sh=> search: ",
          }, function(input)
            vim.cmd(("Cheat %s"):format(input))
          end)
        end,
        mode = { "n" },
        desc = "cheat=> search cheat.sh",
      },
      {
        key_help.cheatsh.no_comments,
        function()
          vim.ui.input({
            prompt = "cheat.sh=> search (no comments): ",
          }, function(input)
            vim.cmd(("CheatWithoutComments %s"):format(input))
          end)
        end,
        mode = { "n" },
        desc = "cheat=> search cheat.sh (no comments)",
      },
    },
  },
  {
    "Djancyp/cheat-sheet",
    opts = {
      auto_fill = {
        filetype = true,
        current_word = true,
      },
      main_win = {
        style = "minimal",
        border = env.borders.main,
      },
      input_win = {
        style = "minimal",
        border = env.borders.main,
      },
    },
    cmd = { "CheatSH" },
    keys = {
      {
        key_help.cheatsh.alt,
        "<CMD>CheatSH<CR>",
        mode = { "n" },
        desc = "cheat=> cheat.sh interface",
      },
    },
  },
  {
    "acuteenvy/tldr.nvim",
    cmd = "Tldr",
    config = function(_, opts)
      require("tldr").setup(opts)
    end,
    opts = {
      client_args = "--color always --render",
      window = {
        height = 0.8,
        width = 0.8,
        border = env.borders.main,
      },
    },
    keys = {
      {
        key_help.tldr,
        "<CMD>Tldr<CR>",
        mode = "n",
        desc = "help.tldr=> view",
      },
    },
  },
}
