local env = require("environment.ui")
local keystems = require("environment.keys").stems
local key_pomodoro = keystems.pomodoro
local key_overseer = keystems.overseer
local key_do = keystems._do

return {
  {
    "wthollingsworth/pomodoro.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      time_work = 50,
      time_break_short = 10,
      time_break_long = 30,
      timers_to_long_break = 2,
      border = { style = env.borders.main },
    },
    cmd = { "PomodoroStart", "PomodoroStop", "PomodoroStatus" },
    keys = {
      {
        key_pomodoro .. "s",
        "<CMD>PomodoroStart<CR>",
        desc = "pomorg=> start pomodoro timer",
        mode = { "n", "v" },
      },
      {
        key_pomodoro .. "q",
        "<CMD>PomodoroStop<CR>",
        desc = "pomorg=> stop pomodoro timer",
        mode = { "n", "v" },
      },
      {
        key_pomodoro .. "u",
        "<CMD>PomodoroStatus<CR>",
        desc = "pomorg=> pomodoro timer status",
        mode = { "n", "v" },
      },
    },
  },
  {
    "nocksock/do.nvim",
    config = true,
    cmd = { "Do", "Done", "DoEdit", "DoSave", "DoToggle" },
    opts = {
      message_timeout = 2000, -- how long notifications are shown
      kaomoji_mode = 0, -- 0 kaomoji everywhere, 1 skip kaomoji in doing
      winbar = false,
      doing_prefix = " current:",
      store = {
        auto_create_file = true, -- automatically create a .do_tasks when calling :Do
        file_name = ".taskmaster_do",
      },
    },
    keys = {
      {
        key_do .. "t",
        function()
          vim.ui.input({
            prompt = "Task Description: ",
          }, function(input)
            vim.cmd(string.format([[Do %s]], input))
          end)
        end,
        mode = "n",
        desc = "do=> add a task",
      },
      {
        key_do .. "T",
        function()
          vim.cmd([[DoToggle]])
        end,
        mode = "n",
        desc = "do=> toggle tasklist view",
      },
      {
        key_do .. "w",
        function()
          vim.cmd([[DoSave]])
        end,
        mode = "n",
        desc = "do=> save tasklist",
      },
      {
        key_do .. "e",
        function()
          vim.cmd([[DoEdit]])
        end,
        mode = "n",
        desc = "do=> edit tasklist in buffer",
      },
      {
        key_do .. "d",
        function()
          vim.cmd([[Done!]])
        end,
        mode = "n",
        desc = "do=> remove task from tasklist",
      },
    },
  },
  { "wakatime/vim-wakatime", event = "VeryLazy", enabled = true },
  {
    "soywod/unfog.vim",
    config = false,
    cmd = "Unfog",
    keys = {
      {
        "<bar>U",
        "<CMD>Unfog<CR>",
        mode = "n",
        desc = "unfog=> list tasks in the mist",
      },
    },
    init = function()
      local mapn = require("environment.keys").map("n")
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "*unfog*" },
        callback = function(ev)
          mapn(
            "gd",
            "<Plug>(unfog-list-done)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "gD",
            "<Plug>(unfog-list-deleted)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "<CR>",
            "<Plug>(unfog-toggle)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "K",
            "<Plug>(unfog-info)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "gc",
            "<Plug>(unfog-context)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "gw",
            "<Plug>(unfog-worktime)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "<C-n>",
            "<Plug>(unfog-next-cell)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "<C-p>",
            "<Plug>(unfog-prev-cell)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "dic",
            "<Plug>(unfog-delete-in-cell)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "cic",
            "<Plug>(unfog-change-in-cell)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
          mapn(
            "vic",
            "<Plug>(unfog-visual-in-cell)",
            { desc = "fog=> list done", buffer = ev.buf }
          )
        end,
      })
    end,
  },
  {
    "stevearc/overseer.nvim",
    config = true,
    opts = {
      templates = { "builtin" },
      task_list = {
        default_detail = 2,
        separator = "🮦🮦🮦🮦🮦🮦🮦🮦🮦🮦🮦",
        direction = "bottom",
      },
      task_launcher = {
        bindings = {
          i = {
            ["<C-s>"] = "Submit",
            ["<C-c>"] = "Cancel",
          },
          n = {
            ["<CR>"] = "Submit",
            ["<C-s>"] = "Submit",
            ["q"] = "Cancel",
            ["?"] = "ShowHelp",
          },
        },
      },
      task_editor = {
        -- Set keymap to false to remove default behavior
        -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
        bindings = {
          i = {
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",
            ["<C-c>"] = "Cancel",
          },
          n = {
            ["<CR>"] = "NextOrSubmit",
            ["<C-s>"] = "Submit",
            ["<Tab>"] = "Next",
            ["<S-Tab>"] = "Prev",
            ["q"] = "Cancel",
            ["?"] = "ShowHelp",
          },
        },
      },
      -- Configure the floating window used for confirmation prompts
      confirm = {
        border = env.borders.main,
        zindex = 40,
        -- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_X and max_X can be a single value or a list of mixed integer/float types.
        min_width = 20,
        max_width = 0.5,
        width = nil,
        min_height = 6,
        max_height = 0.9,
        height = nil,
        -- Set any window options here (e.g. winhighlight)
        win_opts = {
          winblend = 20,
        },
      },
      -- Configuration for task floating windows
      task_win = {
        -- How much space to leave around the floating window
        padding = 2,
        border = env.borders.main,
        -- Set any window options here (e.g. winhighlight)
        win_opts = {
          winblend = 20,
        },
      },
    },
    keys = {
      {
        key_overseer .. "o",
        function()
          require("overseer").open()
        end,
        mode = "n",
        desc = "task.seer=> open overseer",
      },
      {
        key_overseer .. "q",
        function()
          require("overseer").close()
        end,
        mode = "n",
        desc = "task.seer=> close overseer",
      },
      {
        key_overseer .. "v",
        function()
          require("overseer").toggle()
        end,
        mode = "n",
        desc = "task.seer=> toggle overseer",
      },
      {
        key_overseer .. "n",
        function()
          require("overseer").new_task()
        end,
        mode = "n",
        desc = "task.seer=> new overseer task",
      },
      {
        key_overseer .. "b",
        function()
          require("overseer").list_task_bundles()
        end,
        mode = "n",
        desc = "task.seer=> list overseer task bundles",
      },
      {
        key_overseer .. "l",
        function()
          require("overseer").list_tasks()
        end,
        mode = "n",
        desc = "task.seer=> load overseer task bundle",
      },
      {
        key_overseer .. "L",
        function()
          require("overseer").load_task_bundle()
        end,
        mode = "n",
        desc = "task.seer=> load overseer task bundle",
      },
      {
        key_overseer .. "d",
        function()
          require("overseer").load_task_bundle()
        end,
        mode = "n",
        desc = "task.seer=> load overseer task bundle",
      },
      {
        key_overseer .. "rr",
        function()
          require("overseer").run_template()
        end,
        mode = "n",
        desc = "task.seer=> run overseer template",
      },
      {
        key_overseer .. "ra",
        function()
          require("overseer").run_action()
        end,
        mode = "n",
        desc = "task.seer=> run overseer action",
      },
    },
  },
  {
    "https://git.sr.ht/~soywod/himalaya-vim",
    config = function(_, opts)
      vim.cmd([[syntax on]])
      vim.cmd([[filetype plugin on]])
      vim.opt.hidden = true

      vim.g.himalaya_folder_picker = "fzf"
    end,
    cmd = "Himalaya",
    keys = {
      {
        "<F9>",
        "<CMD>Himalaya<CR>",
        mode = "n",
        desc = "mail=> update servers and view mail",
      },
    },
  },
}
