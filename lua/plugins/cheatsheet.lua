local env = require("environment.ui")
local stems = require("environment.keys").stems

return {
  {
    "sudormrfbin/cheatsheet.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = function(_, opts)
      require("telescope").load_extension("cheatsheet")
      opts = vim.tbl_extend("force", {
        bundled_cheatsheets = true,
        bundled_plugin_cheatsheets = true,
        include_only_installed_plugins = true,
      }, opts or {})
    end,
    keys = {
      {
        "<F2>",
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
        "<F3>",
        function()
          vim.ui.input({
            prompt = "cheat.sh=> search: ",
          }, function(input)
            local ok, res = pcall(vim.cmd, ("Cheat %s"):format(input))
          end)
        end,
        mode = { "n" },
        desc = "cheat=> search cheat.sh",
      },
      {
        "<F4>",
        function()
          vim.ui.input({
            prompt = "cheat.sh=> search (no comments): ",
          }, function(input)
            local ok, res =
              pcall(vim.cmd, ("CheatWithoutComments %s"):format(input))
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
        "<F5>",
        "<CMD>CheatSH<CR>",
        mode = { "n" },
        desc = "cheat=> cheat.sh interface",
      },
    },
  },
}
