local env = require("environment.ui")
local stems = require("environment.keys").stems
local key_git = stems.git
local key_undotree = stems.undotree

return {
  {
    "jiaoshijie/undotree",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    keys = {
      {
        key_undotree .. "t",
        function()
          require("undotree").toggle()
        end,
        mode = "n",
        desc = "undo=> toggle history tree",
        noremap = true,
        silent = true,
      },
      {
        key_undotree .. "o",
        function()
          require("undotree").open()
        end,
        mode = "n",
        desc = "undo=> open history tree",
        noremap = true,
        silent = true,
      },
      {
        key_undotree .. "q",
        function()
          require("undotree").close()
        end,
        mode = "n",
        desc = "undo=> close history tree",
        noremap = true,
        silent = true,
      },
    },
    opts = {
      float_diff = false, -- using float window previews diff, set this `true` will disable layout option
      layout = "left_left_bottom", -- "left_bottom", "left_left_bottom"
      ignore_filetype = env.ft_ignore_list,
      window = {
        winblend = 20,
      },
      keymaps = {
        ["j"] = "move_next",
        ["k"] = "move_prev",
        ["J"] = "move_change_next",
        ["K"] = "move_change_prev",
        ["<cr>"] = "action_enter",
        ["p"] = "enter_diffbuf",
        ["q"] = "quit",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "f-person/git-blame.nvim",
    cmd = { "GitBlameToggle", "GitBlameEnable" },
    init = function()
      vim.g.gitblame_delay = 1000
    end,
    keys = {
      {
        "<leader>gb",
        "<CMD>GitBlameToggle<CR>",
        mode = { "n", "v" },
        desc = "git=> toggle git blame on line",
      },
      {
        "<leader>gB",
        "<CMD>GitBlameEnable<CR>",
        mode = { "n", "v" },
        desc = "git=> force enable git blame on line",
      },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Neogit" },
    opts = {
      disable_commit_confirmation = true,
      disable_insert_on_commit = "auto",
      signs = {
        section = { "󰄾", "󰄼" },
        item = { "󰅂", "󰅀" },
        hunk = { "󰧛", "󰧗" },
      },
      integrations = { telescope = true, diffview = true },
    },
    keys = {
      {
        key_git .. "n",
        "<CMD>Neogit<CR>",
        mode = { "n", "v" },
        desc = "git=> neogit",
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    config = true,
    version = "*",
    cmd = {
      "GitConflictChooseOurs",
      "GitConflictChooseTheirs",
      "GitConflictChooseBoth",
      "GitConflictChooseNone",
      "GitConflictNextConflict",
      "GitConflictPrevConflict",
      "GitConflictListQf",
    },
  },
}
