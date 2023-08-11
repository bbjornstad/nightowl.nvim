local env = require("environment.ui")
local stems = require("environment.keys").stems
local key_git = stems.git
local key_undotree = stems.undotree
local key_versioning = "gs"

return {
  {
    "kevinhwang91/nvim-fundo",
    opts = {
      archives_dir = vim.fn.stdpath("cache") .. "/fundo",
      limit_archives_size = 256,
    },
    config = true,
    init = function()
      vim.o.undofile = true
    end,
    build = function(_)
      require("fundo").install()
    end,
    event = "VeryLazy",
  },
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
    keys = {
      {
        key_versioning .. "d",
        "<CMD>DiffviewOpen<CR>",
        mode = "n",
        desc = "git=> compare in diffview",
      },
    },
  },
  {
    "f-person/git-blame.nvim",
    cmd = { "GitBlameToggle", "GitBlameEnable" },
    init = function()
      vim.g.gitblame_delay = 1000
    end,
    keys = {
      {
        key_git .. "Bl",
        "<CMD>GitBlameToggle<CR>",
        mode = { "n" },
        desc = "git=> toggle git blame on line",
      },
      {
        key_git .. "Be",
        "<CMD>GitBlameEnable<CR>",
        mode = { "n" },
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
        mode = { "n" },
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
    keys = {
      {
        key_git .. "fq",
        "<CMD>GitConflictListQf<CR>",
        mode = "n",
        desc = "git=> conflict quick fix",
      },
      {
        key_git .. "fo",
        "<CMD>GitConflictChooseOurs<CR>",
        mode = "n",
        desc = "git=> conflict choose ours",
      },
      {
        key_git .. "ft",
        "<CMD>GitConflictChooseTheirs<CR>",
        mode = "n",
        desc = "git=> conflict choose theirs",
      },
      {
        key_git .. "fb",
        "<CMD>GitConflictChooseBoth<CR>",
        mode = "n",
        desc = "git=> conflict choose both",
      },
      {
        key_git .. "fe",
        "<CMD>GitConflictChooseNone<CR>",
        mode = "n",
        desc = "git=> conflict choose none",
      },
      {
        key_git .. "fn",
        "<CMD>GitConflictNextConflict<CR>",
        mode = "n",
        desc = "git=> next conflict",
      },
      {
        key_git .. "fp",
        "<CMD>GitConflictPrevConflict<CR>",
        mode = "n",
        desc = "git=> previous conflict",
      },
    },
  },
  {
    "APZelos/blamer.nvim",
    config = function(_, opts)
      vim.g.blamer_enabled = 1
      vim.g.blamer_delay = 1000
      vim.g.blamer_show_in_visual_modes = 0
      vim.g.blamer_prefix = "  "
      vim.g.blamer_template = "<committer>@<committer-time>  <summary>"
      vim.g.blamer_relative_time = 1
    end,
    keys = {
      {
        key_git .. "bb",
        "<CMD>BlamerToggle<CR>",
        mode = "n",
        desc = "git=> toggle global blamer",
      },
      {
        key_git .. "bi",
        "<leader>gbi",
        function()
          vim.g.blamer_show_in_insert_modes = 1
        end,
        mode = "n",
        desc = "git=> show global blamer in insert mode",
      },
      {
        key_git .. "bv",
        function()
          vim.g.blamer_show_in_visual_modes = 1
        end,
        mode = "n",
        desc = "git=> show global blamer in visual mode",
      },
    },
  },
  {
    "mcchrish/info-window.nvim",
    cmd = "InfoWindowToggle",
    keys = {
      {
        key_versioning .. "i",
        "<CMD>InfoWindowToggle<CR>",
        mode = "n",
        desc = "info=> buffer metadata/file info",
      },
    },
  },
  {
    "topaxi/gh-actions.nvim",
    cmd = "GhActions",
    keys = {
      {
        "<leader>ga",
        "<cmd>GhActions<cr>",
        mode = "n",
        desc = "git=> Github Actions",
      },
    },
    -- optional, you can also install and use `yq` instead.
    build = "make",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    opts = {},
    config = function(_, opts)
      require("gh-actions").setup(opts)
    end,
  },
}
