local env = require("environment.ui")

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
        "<F3>",
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
        "<F4>",
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
        "<F5>",
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
        "<F6>",
        "<CMD>CheatSH<CR>",
        mode = { "n" },
        desc = "cheat=> cheat.sh interface",
      },
    },
  },
}
