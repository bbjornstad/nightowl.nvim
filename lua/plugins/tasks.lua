local env = require("environment.ui")
local inp = require("uutils.input")
local keystems = require("environment.keys").stems
local key_pomodoro = keystems.pomodoro
local key_overseer = keystems.overseer
local key_do = keystems._do
local key_conduct = keystems.conduct
local key_taskorg = keystems.base.tasks
local key_memento = keystems.memento
local key_pulse = keystems.pulse
local key_mountaineer = keystems.mountaineer
local key_executor = keystems.executor
local xtscope = require("uutils.scope").extendoscope

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
        mode = { "n" },
      },
      {
        key_pomodoro .. "q",
        "<CMD>PomodoroStop<CR>",
        desc = "pomorg=> stop pomodoro timer",
        mode = { "n" },
      },
      {
        key_pomodoro .. "u",
        "<CMD>PomodoroStatus<CR>",
        desc = "pomorg=> pomodoro timer status",
        mode = { "n" },
      },
    },
  },
  {
    "nfrid/due.nvim",
    config = true,
    opts = {
      prescript = "󰅑 due: ",
      due_hi = "NightowlStartupEntry",
      use_clock_time = true,
      use_clock_today = true,
      use_seconds = true,
      overdue = "󱫧 overdue: ",
    },
    event = "VeryLazy",
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
  { "wakatime/vim-wakatime", event = { "VeryLazy" }, enabled = true },
  {
    "gaborvecsei/usage-tracker.nvim",
    event = "BufWinEnter",
    enabled = true,
    opts = {
      keep_eventlog_days = 14,
      cleanup_freq_days = 7,
      event_wait_period_in_sec = 5,
      inactivity_threshold_in_min = 5,
      inactivity_check_freq_in_sec = 5,
      verbose = 0,
    },
  },
  {
    "stevearc/overseer.nvim",
    config = true,
    opts = {
      templates = { "builtin" },
      task_list = {
        default_detail = 3,
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
      vim.opt.hidden = opts.hidden or true

      vim.g.himalaya_folder_picker = "fzf"
    end,
    cmd = "Himalaya",
    keys = {
      {
        "<F11>",
        "<CMD>Himalaya<CR>",
        mode = "n",
        desc = "mail=> update servers and view mail",
      },
    },
  },
  {
    "elmarsto/mountaineer.nvim",
    cmd = "Himalaya",
    keys = {
      {
        key_mountaineer,
        "<CMD>Telescope mountaineer<CR>",
        mode = "n",
        desc = "mail=> telescope view mail",
      },
      {
        "<F12>",
        "<CMD>Telescope mountaineer<CR>",
        mode = "n",
        desc = "mail=> telescope view mail",
      },
    },
  },
  {
    "aaditeynair/conduct.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      functions = {},
      presets = {},
      hooks = {
        before_session_save = function() end,
        before_session_load = function() end,
        after_session_load = function() end,
        before_project_load = function() end,
        after_project_load = function() end,
      },
    },
    config = function(_, opts)
      require("conduct").setup(opts)
      require("telescope").load_extension("conduct")
    end,
    cmd = {
      -- project commands
      "ConductNewProject",
      "ConductLoadProject",
      "ConductLoadLastProject",
      "ConductLoadCwdProject",
      "ConductRenameProject",
      "ConductDeleteProject",
      "ConductLoadProjectConfig",
      "ConductReloadProjectConfig",
      -- session commands
      "ConductProjectNewSession",
      "ConductProjectLoadSession",
      "ConductProjectDeleteSession",
      "ConductProjectRenameSession",
    },
    keys = {
      {
        key_conduct .. "l",
        inp.name([[ConductLoadProject %s]]),
        mode = "n",
        desc = "conduct=> load project",
      },
      {
        key_conduct .. "L",
        "<CMD>ConductLoadLastProject<CR>",
        mode = "n",
        desc = "conduct=> load last project",
      },
      {
        key_conduct .. ".",
        "<CMD>ConductLoadCwdProject<CR>",
        mode = "n",
        desc = "conduct=> load cwd project",
      },
      {
        key_conduct .. "n",
        inp.name([[ConductNewProject %s]]),
        mode = "n",
        desc = "conduct=> new project",
      },
      {
        key_conduct .. "r",
        "<CMD>ConductRenameProject<CR>",
        mode = "n",
        desc = "conduct=> rename project",
      },
      {
        key_conduct .. "d",
        inp.name([[ConductDeleteProject %s]]),
        mode = "n",
        desc = "conduct=> delete project",
      },
      {
        key_conduct .. "cp",
        inp.name([[ConductLoadProjectConfig %s]]),
        mode = "n",
        desc = "conduct=> load project config",
      },
      {
        key_conduct .. "cr",
        "<CMD>ConductReloadProjectConfig<CR>",
        mode = "n",
        desc = "conduct=> reload project config",
      },
      {
        key_conduct .. "sn",
        inp.name([[ConductProjectNewSession %s]]),
        mode = "n",
        desc = "conduct=> new session in project",
      },
      {
        key_conduct .. "sl",
        inp.name([[ConductProjectLoadSession %s]]),
        mode = "n",
        desc = "conduct=> load session in project",
      },
      {
        key_conduct .. "sd",
        inp.name([[ConductProjectDeleteSession %s]]),
        mode = "n",
        desc = "conduct=> delete session in project",
      },
      {
        key_conduct .. "sr",
        "<CMD>ConductProjectRenameSession<CR>",
        mode = "n",
        desc = "conduct=> rename session in project",
      },
      {
        "<leader>fp",
        function()
          xtscope("conduct", "projects", {})
        end,
        mode = "n",
        desc = "conduct=> projects",
      },
      {
        "<leader>fs",
        function()
          xtscope("conduct", "sessions", {})
        end,
        mode = "n",
        desc = "conduct=> sessions",
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
        key_memento .. "m",
        function()
          require("memento").toggle()
        end,
        mode = "n",
        desc = "mem=> recently closed files",
      },
      {
        key_memento .. "c",
        function()
          require("memento").clear_history()
        end,
        mode = "n",
        desc = "mem=> clear closed file history",
      },
    },
  },
  {
    "linguini1/pulse.nvim",
    version = "*",
    cmd = {
      "PulseEnable",
      "PulseDisable",
      "Pulses",
      "PulseList",
      "PulseStatus",
    },
    opts = {
      level = vim.log.levels.INFO,
    },
    config = function(_, opts)
      require("pulse").setup(opts)
    end,
    init = function()
      require("pulse").add("standard pom", 53, "work time...", false)
      require("pulse").add("standard break", 17, "take a break...", false)
    end,
    keys = {
      {
        key_pulse .. "n",
        function()
          inp.callback_input("timer:", function(input)
            require("pulse").add(
              "custom_timer" .. input,
              input,
              "work time...",
              true
            )
          end)
        end,
        mode = "n",
        desc = "pulse=> new custom timer",
      },
      {
        key_pulse .. "N",
        function()
          inp.callback_input("timer:", function(input)
            require("pulse").add(
              "custom_timer" .. input,
              input,
              "work time...",
              false
            )
          end)
        end,
        mode = "n",
        desc = "pulse=> new custom timer (no enable)",
      },
      {
        key_pulse .. "t",
        function()
          require("pulse").enable("standard pom")
        end,
        mode = "n",
        desc = "pulse=> standard timer",
      },
      {
        key_pulse .. "T",
        function()
          require("pulse").disable("standard pom")
        end,
        mode = "n",
        desc = "pulse=> standard timer",
      },
      {
        key_pulse .. "p",
        function()
          require("pulse").pick_timers()
        end,
        mode = "n",
        desc = "pulse=> standard timer",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        [key_taskorg] = { name = "task/time management" },
      },
    },
  },
  {
    "google/executor.nvim",
    config = true,
    opts = {
      use_split = true,
      split = {
        position = "right",
      },
    },
    keys = {
      {
        key_executor,
        "<CMD>ExecutorRun<CMD>",
        mode = "n",
        desc = "repl.gexec=> run",
      },
    },
  },
}
