local env = require("environment.ui")
local inp = require("parliament.utils.input")
local kenv = require("environment.keys")
local opt = require("environment.optional")
local key_time = kenv.time
local key_pomodoro = key_time.pomodoro
local key_pulse = key_time.pulse
local key_mail = kenv.mail
local key_sc = kenv.shortcut

return {
  {
    "nfrid/due.nvim",
    config = function(_, opts)
      require("due_nvim").setup(opts)
    end,
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
        key_mail.himalaya,
        "<CMD>Himalaya<CR>",
        mode = "n",
        desc = "::mail=> update servers and view mail",
      },
    },
  },
  {
    "elmarsto/mountaineer.nvim",
    dependencies = { "https://git.sr.ht/~soywod/himalaya-vim" },
    cmd = "Himalaya",
    keys = {
      {
        key_mail.mountaineer,
        "<CMD>Telescope mountaineer<CR>",
        mode = "n",
        desc = "::mail=> telescope view mail",
      },
    },
  },
  {
    "linguini1/pulse.nvim",
    enabled = opt.prefer.timers.pomodoro == "pulse.nvim",
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
      require("pulse").add("standard", { interval = 53 })
      require("pulse").add("break:standard", { interval = 17 })
    end,
    keys = {
      {
        key_pulse.new_custom,
        function()
          inp.callback_input("timer:", function(input)
            require("pulse").add("custom_timer" .. input, { interval = input })
          end)
        end,
        mode = "n",
        desc = "::pulse=> new custom timer",
      },
      {
        key_pulse.new_disabled_custom,
        function()
          inp.callback_input("timer:", function(input)
            require("pulse").add("custom_timer" .. input, { interval = input })
          end)
        end,
        mode = "n",
        desc = "::pulse=> new custom timer (no enable)",
      },
      {
        key_pulse.enable_standard,
        function()
          require("pulse").enable("standard")
        end,
        mode = "n",
        desc = "::pulse=> enable standard",
      },
      {
        key_pulse.disable_standard,
        function()
          require("pulse").disable("standard")
        end,
        mode = "n",
        desc = "::pulse=> disable standard",
      },
      {
        key_pulse.pick,
        function()
          require("pulse").pick_timers()
        end,
        mode = "n",
        desc = "::pulse=> pick timer",
      },
    },
  },
  {
    "Lamby777/timewasted.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("timewasted").setup(opts)
    end,
    opts = function()
      return {
        autosave_delay = 30,
        time_formatter = function(total_sec)
          local d, h, m = unpack(require("timewasted").dhms(total_sec))
          local time_str = string.format("%2dd %02dh %02dm", d, h, m)

          return string.format("TWC: %s", time_str)
        end,
      }
    end,
  },
  {
    "mvllow/stand.nvim",
    opts = {
      minute_interval = 100,
    },
    config = function(_, opts)
      require("stand").setup(opts)
    end,
    event = "VeryLazy",
    keys = {
      {
        key_time.stand.now,
        "<CMD>StandNow<CR>",
        mode = "n",
        desc = "time.stand=> now",
      },
      {
        key_time.stand.every,
        "<CMD>StandEvery<CR>",
        mode = "n",
        desc = "time.stand=> set interval",
      },
      {
        key_time.stand.disable,
        "<CMD>StandDisable<CR>",
        mode = "n",
        desc = "time.stand=> disable",
      },
      {
        key_time.stand.enable,
        "<CMD>StandEnable<CR>",
        mode = "n",
        desc = "time.stand=> enable",
      },
      {
        key_time.stand.when,
        "<CMD>StandWhen<CR>",
        mode = "n",
        desc = "time.stand=> when",
      },
    },
  },
  {
    "stefanlogue/hydrate.nvim",
    event = "VeryLazy",
    opts = {
      minute_interval = 60,
      render_style = "default",
      persist_timer = false,
    },
    config = function(_, opts)
      require("hydrate").setup(opts)
    end,
  },
  {
    "lazymaniac/wttr.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function(_, opts)
      require("wttr").setup(opts)
    end,
    event = "VeryLazy",
    opts = {
      location = "Denver",
      -- format = 4,
      custom_format = "%C+%cP:%p+T:%t+F:%f+%w+%m+%P+UV:%u+Hum:%h",
    },
    keys = {
      {
        key_sc.weather.open,
        function()
          require("wttr").get_forecast()
        end,
        mode = "n",
        desc = "wttr |=> conditions",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "lazymaniac/wttr.nvim",
    },
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_z = vim.list_extend(opts.sections.lualine_z or {}, {
        "require'wttr'.text",
      })
    end,
  },
}
