local env = require("environment.ui")
local inp = require("uutils.input")
local stems = require("environment.keys")
local key_pomodoro = stems.time.pomodoro
local key_taskorg = stems.time:leader()
local key_memento = stems.fm.memento
local key_pulse = stems.time.pulse
local key_mountaineer = stems.mail.mountaineer

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
      require("pulse").add("standard pom", { interval = 53 })
      require("pulse").add("standard break", { interval = 17 })
    end,
    keys = {
      {
        key_pulse .. "n",
        function()
          inp.callback_input("timer:", function(input)
            require("pulse").add("custom_timer" .. input, { interval = input })
          end)
        end,
        mode = "n",
        desc = "pulse=> new custom timer",
      },
      {
        key_pulse .. "N",
        function()
          inp.callback_input("timer:", function(input)
            require("pulse").add("custom_timer" .. input, { interval = input })
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
}
