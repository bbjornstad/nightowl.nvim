local env = require("environment.ui")
local kenv = require("environment.keys")
local opt = require("environment.optional")
local key_view = kenv.view
local key_git = kenv.git
local key_session = kenv.session

local function session_files(file)
  local lines = {}
  local cwd, cwd_pat = "", "^cd%s*"
  local buf_pat = "^badd%s*%+%d+%s*"
  for line in io.lines(file) do
    if string.find(line, cwd_pat) then
      cwd = line:gsub("%p", "%%%1")
    end
    if string.find(line, buf_pat) then
      lines[#lines + 1] = line
    end
  end
  local buffers = {}
  for k, v in pairs(lines) do
    buffers[k] =
      v:gsub(buf_pat, ""):gsub(cwd:gsub("cd%s*", ""), ""):gsub("^/?%.?/", "")
  end
  return buffers
end

return {
  {
    "kevinhwang91/nvim-fundo",
    opts = {
      archives_dir = vim.fn.stdpath("cache") .. "/fundo",
      limit_archives_size = 256,
    },
    config = function(_, opts)
      require("fundo").setup(opts)
    end,
    init = function()
      vim.o.undofile = true
    end,
    build = function(_)
      require("fundo").install()
    end,
    event = { "VeryLazy" },
  },
  {
    "jiaoshijie/undotree",
    enabled = opt.undotree,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      require("undotree").setup(opts)
    end,
    keys = {
      {
        key_view.undotree.toggle,
        function()
          require("undotree").toggle()
        end,
        mode = "n",
        desc = "::undo=> toggle tree",
        noremap = true,
        silent = true,
      },
      {
        key_view.undotree.open,
        function()
          require("undotree").open()
        end,
        mode = "n",
        desc = "::undo=> open tree",
        noremap = true,
        silent = true,
      },
      {
        key_view.undotree.close,
        function()
          require("undotree").close()
        end,
        mode = "n",
        desc = "::undo=> close tree",
        noremap = true,
        silent = true,
      },
    },
    opts = {
      float_diff = false, -- using float window previews diff, set this `true` will disable layout option
      layout = "left_left_bottom", -- "left_bottom", "left_left_bottom"
      ignore_filetype = env.ft_ignore_list,
      window = { winblend = 20 },
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
        key_git.diffview,
        "<CMD>DiffviewOpen<CR>",
        mode = "n",
        desc = "::git.diff=> compare",
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
        section = { "󰧛", "󰧗" },
        item = { "󰄾", "󰄼" },
        hunk = { "󰅂", "󰅀" },
      },
      integrations = { telescope = true, diffview = true },
    },
    keys = {
      {
        key_git.neogit,
        "<CMD>Neogit<CR>",
        mode = { "n" },
        desc = "::git.neo=> open",
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    enabled = opt.git.git_conflict,
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
        key_git.conflict.quickfix,
        "<CMD>GitConflictListQf<CR>",
        mode = "n",
        desc = "::git.conflict=> quick fix",
      },
      {
        key_git.conflict.choose_ours,
        "<CMD>GitConflictChooseOurs<CR>",
        mode = "n",
        desc = "::git.conflict=> choose ours",
      },
      {
        key_git.conflict.choose_theirs,
        "<CMD>GitConflictChooseTheirs<CR>",
        mode = "n",
        desc = "::git.conflict=> choose theirs",
      },
      {
        key_git.conflict.choose_both,
        "<CMD>GitConflictChooseBoth<CR>",
        mode = "n",
        desc = "::git.conflict=> choose both",
      },
      {
        key_git.conflict.choose_none,
        "<CMD>GitConflictChooseNone<CR>",
        mode = "n",
        desc = "::git.conflict=> choose none",
      },
      {
        key_git.conflict.next,
        "<CMD>GitConflictNextConflict<CR>",
        mode = "n",
        desc = "::git.conflict=> next",
      },
      {
        key_git.conflict.previous,
        "<CMD>GitConflictPrevConflict<CR>",
        mode = "n",
        desc = "::git.conflict=> previous",
      },
    },
  },
  {
    "mcchrish/info-window.nvim",
    cmd = "InfoWindowToggle",
    keys = {
      {
        key_view.infowindow,
        "<CMD>InfoWindowToggle<CR>",
        mode = "n",
        desc = "::info=> buffer metadata/file info",
      },
    },
  },
  {
    "topaxi/gh-actions.nvim",
    enabled = opt.gh_actions,
    cmd = "GhActions",
    keys = {
      {
        key_git.gh_actions,
        "<cmd>GhActions<cr>",
        mode = "n",
        desc = "::git=> Github Actions",
      },
    },
    -- optional, you can also install and use `yq` instead.
    build = "make",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    config = function(_, opts)
      require("gh-actions").setup(opts)
    end,
  },
  {
    "niuiic/git-log.nvim",
    opts = {
      extra_args = {},
      win = {
        border = env.borders.main,
        width_ratio = 0.6,
        height_ratio = 0.6,
      },
      keymap = { close = "q" },
    },
    config = function(_, opts)
      require("git-log").setup(opts)
    end,
    keys = {
      {
        key_git.log,
        function()
          require("git-log").check_log()
        end,
        mode = { "n" },
        -- mode = { "n", "v" },
        desc = "::git.log=> check",
      },
    },
  },
  {
    "FredeEB/tardis.nvim",
    cmd = "Tardis",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keymap = {
        next = key_git:next(),
        prev = key_git:previous(),
        quit = key_git:close(),
        commit_message = "m",
      },
    },
    config = function(_, opts)
      require("tardis-nvim").setup(opts)
    end,
    keys = {
      {
        key_git.tardis,
        "<CMD>Tardis<CR>",
        mode = "n",
        desc = "::git.tardis=> open",
      },
    },
  },
  {
    "gennaro-tedesco/nvim-possession",
    dependencies = { "ibhagwan/fzf-lua" },
    opts = { autoswitch = { enable = true } },
    config = function(_, opts)
      require("nvim-possession").setup(opts)
    end,
    keys = {
      {
        key_session.list,
        function()
          require("nvim-possession").list()
        end,
        mode = "n",
        desc = "session=> list",
      },
      {
        key_session.new,
        function()
          require("nvim-possession").new()
        end,
        mode = "n",
        desc = "session=> new",
      },
      {
        key_session.update,
        function()
          require("nvim-possession").update()
        end,
        mode = "n",
        desc = "session=> update",
      },
      {
        key_session.delete,
        function()
          require("nvim-possession").delete()
        end,
        mode = "n",
        desc = "session=> delete",
      },
    },
  },
  {
    "willothy/savior.nvim",
    dependencies = { "j-hui/fidget.nvim" },
    event = { "InsertEnter", "TextChanged" },
    opts = {
      events = {
        immediate = { "FocusLost", "BufLeave" },
        deferred = { "InsertLeave", "TextChanged" },
        cancel = { "InsertEnter", "BufWritePost", "TextChanged" },
      },
      callbacks = {},
      throttle_ms = 3000,
      interval_ms = 30000,
      defer_ms = 1000,
    },
  },
  {
    "echasnovski/mini.visits",
    config = function(_, opts)
      require("mini.visits").setup(opts)
    end,
    opts = {},
    keys = {},
    event = "VeryLazy",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
    event = "VeryLazy",
    opts = {
      signs = {},
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = opt.prefer.gitblame == "gitsigns",
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "overlay",
        delay = 5000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "   <author>: [<author_time:%Y-%m-%d %H:%M>] 󱛠 <summary>",
      sign_priority = 5,
      update_debounce = 200,
      status_formatter = nil,
      max_file_length = 100000,
      preview_config = {
        border = env.borders.main,
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      yadm = { enable = false },
    },
    keys = {
      {
        key_git.gitsigns.toggle.numhl,
        function()
          require("gitsigns").toggle_numhl()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> numhl",
      },
      {
        key_git.gitsigns.toggle.linehl,
        function()
          require("gitsigns").toggle_linehl()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> linehl",
      },
      {
        key_git.gitsigns.toggle.signs,
        function()
          require("gitsigns").toggle_signs()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> signs",
      },
      {
        key_git.gitsigns.toggle.word_diff,
        function()
          require("gitsigns").toggle_word_diff()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> word diff",
      },
      {
        key_git.gitsigns.toggle.line_blame,
        function()
          require("gitsigns").toggle_current_line_blame()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> line blame",
      },
      {
        key_git.gitsigns.toggle.deleted,
        function()
          require("gitsigns").toggle_deleted()
        end,
        mode = "n",
        desc = "git:tgl| signs |=> deleted",
      },
      {
        key_git.gitsigns.preview.hunk,
        function()
          require("gitsigns").preview_hunk()
        end,
        mode = "n",
        desc = "git:view| signs |=> hunk",
      },
      {
        key_git.gitsigns.preview.hunk_inline,
        function()
          require("gitsigns").preview_hunk_inline()
        end,
        mode = "n",
        desc = "git:view| signs |=> inline hunk",
      },
      {
        key_git.gitsigns.refresh,
        function()
          require("gitsigns").refresh()
        end,
        mode = "n",
        desc = "git:view| signs |=> inline hunk",
      },
      {
        key_git.gitsigns.diffthis,
        function()
          require("gitsigns").diffthis()
        end,
        mode = "n",
        desc = "git:diff| signs |=> diffthis",
      },
    },
  },
}
