local env = require("environment.ui")
local keystems = require("environment.keys").stems
local key_pomodoro = keystems.pomodoro

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
        "|t",
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
        "|T",
        function()
          vim.cmd([[DoToggle]])
        end,
        mode = "n",
        desc = "do=> toggle tasklist",
      },
      {
        "|w",
        function()
          vim.cmd([[DoSave]])
        end,
        mode = "n",
        desc = "do=> save tasklist",
      },
      {
        "|e",
        function()
          vim.cmd([[DoEdit]])
        end,
        mode = "n",
        desc = "do=> save tasklist",
      },
      {
        "|d",
        function()
          vim.cmd([[Done!]])
        end,
        mode = "n",
        desc = "do=> save tasklist",
      },
    },
  },
  { "wakatime/vim-wakatime", event = "VeryLazy", enabled = true },
}
