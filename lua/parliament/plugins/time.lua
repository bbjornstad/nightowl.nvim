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
    end,
    opts = {
      hidden = true,
    },
    init = function()
      vim.g.himalaya_folder_picker = "fzf"
      local cmdr = require("funsak.autocmd").autocmdr("Himalaya", true)
      cmdr({ "FileType" }, {
        pattern = { "himalaya-email-listing", "mail" },
        callback = function(ev)
          local mapx = vim.keymap.set
          local opts = { buffer = ev.buf, remap = false }
          local mapn = function(lhs, rhs, desc, op)
            return mapx(
              "n",
              lhs,
              rhs,
              vim.tbl_deep_extend("force", opts, op or {}, { desc = desc })
            )
          end
          mapn(
            key_mail.action.change_folder,
            "<plug>(himalaya-folder-select)",
            "mail:| folder |=> goto"
          )
          mapn(
            key_mail.action.page.next,
            "<plug>(himalaya-folder-select-next-page)",
            "mail:| folder |=> next page"
          )
          mapn(
            key_mail.action.page.previous,
            "<plug>(himalaya-folder-select-previous-page)",
            "mail:| folder |=> previous page"
          )
          mapn(
            key_mail.action.read,
            "<plug>(himalaya-email-read)",
            "mail:| message |=> read"
          )
          mapn(
            key_mail.action.compose,
            "<plug>(himalaya-email-write)",
            "mail:| message |=> write"
          )
          mapn(
            key_mail.action.reply,
            "<plug>(himalaya-email-reply)",
            "mail:| message |=> reply"
          )
          mapn(
            key_mail.action.reply_all,
            "<plug>(himalaya-email-reply-all)",
            "mail:| message |=> reply all"
          )
          mapn(
            key_mail.action.forward,
            "<plug>(himalaya-email-forward)",
            "mail:| message |=> forward"
          )
          mapn(
            key_mail.action.download_attachments,
            "<plug>(himalaya-email-download-attachments)",
            "mail:| message |=> download attachments"
          )
          mapn(
            key_mail.action.locate.copy,
            "<plug>(himalaya-email-copy)",
            "mail:| message |=> copy"
          )
          mapn(
            key_mail.action.locate.move,
            "<plug>(himalaya-email-move)",
            "mail:| message |=> move"
          )
          mapn(
            key_mail.action.locate.delete,
            "<plug>(himalaya-email-delete)",
            "mail:| message |=> delete"
          )
          mapn(
            key_mail.action.add_attachment,
            "<plug>(himalaya-email-add-attachment)",
            "mail:| message |=> add attachment"
          )
        end,
      })
    end,
    cmd = "Himalaya",
    keys = {
      {
        key_mail.himalaya,
        "<CMD>Himalaya<CR>",
        mode = "n",
        desc = "mail:| himalaya |=> update & view",
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
        desc = "pulse:| new |=> custom now",
      },
      {
        key_pulse.new_disabled_custom,
        function()
          inp.callback_input("timer:", function(input)
            require("pulse").add("custom_timer" .. input, { interval = input })
          end)
        end,
        mode = "n",
        desc = "pulse:| new |=> custom promise",
      },
      {
        key_pulse.enable_standard,
        function()
          require("pulse").enable("standard")
        end,
        mode = "n",
        desc = "pulse:| std |=> enable",
      },
      {
        key_pulse.disable_standard,
        function()
          require("pulse").disable("standard")
        end,
        mode = "n",
        desc = "pulse:| std |=> disable",
      },
      {
        key_pulse.pick,
        function()
          require("pulse").pick_timers()
        end,
        mode = "n",
        desc = "pulse:| <all> |=> pick",
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

          return time_str
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
        desc = "time:| stand |=> now",
      },
      {
        key_time.stand.every,
        "<CMD>StandEvery<CR>",
        mode = "n",
        desc = "time:| stand |=> set interval",
      },
      {
        key_time.stand.disable,
        "<CMD>StandDisable<CR>",
        mode = "n",
        desc = "time:| stand |=> disable",
      },
      {
        key_time.stand.enable,
        "<CMD>StandEnable<CR>",
        mode = "n",
        desc = "time:| stand |=> enable",
      },
      {
        key_time.stand.when,
        "<CMD>StandWhen<CR>",
        mode = "n",
        desc = "time:| stand |=> when",
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
      custom_format = "%l:%x:%f::%M",
    },
    keys = {
      {
        key_sc.weather.open,
        function()
          require("wttr").get_forecast()
        end,
        mode = "n",
        desc = "wttr:| conditions |=> float",
      },
    },
  },
  {
    "liljaylj/codestats.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "TextChanged", "InsertEnter" },
    cmd = { "CodeStatsXpSend", "CodeStatsProfileUpdate" },
    config = function()
      require("codestats").setup({
        username = "ursa-major", -- needed to fetch profile data
        base_url = "https://codestats.net", -- codestats.net base url
        api_key = os.getenv("CODESTATS_API_KEY"),
        send_on_exit = true, -- send xp on nvim exit
        send_on_timer = true, -- send xp on timer
        timer_interval = 60000, -- timer interval in milliseconds (minimum 1000ms to prevent DDoSing codestat.net servers)
        curl_timeout = 5, -- curl request timeout in seconds
      })
    end,
  },
}
