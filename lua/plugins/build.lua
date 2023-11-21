local kenv = require("environment.keys").build
local key_overseer = kenv.overseer
local key_runner = kenv.runner
local key_executor = kenv.executor
local key_rapid = kenv.rapid
local key_launch = kenv.launch
local env = require("environment.ui")

return {
  {
    "google/executor.nvim",
    cmd = { "ExecutorRun" },
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
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerClose" },
    dependencies = { "stevearc/overseer.nvim" },
  },
  {
    "stevearc/overseer.nvim",
    config = true,
    opts = {
      templates = { "builtin" },
      task_list = {
        default_detail = 3,
        separator = "🮦",
        direction = "bottom",
        min_height = 25,
        max_height = 32,
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
        key_overseer.open,
        function()
          require("overseer").open()
        end,
        mode = "n",
        desc = "task.seer=> open overseer",
      },
      {
        key_overseer.close,
        function()
          require("overseer").close()
        end,
        mode = "n",
        desc = "task.seer=> close overseer",
      },
      {
        key_overseer.toggle,
        function()
          require("overseer").toggle()
        end,
        mode = "n",
        desc = "task.seer=> toggle overseer",
      },
      {
        key_overseer.task.new,
        function()
          require("overseer").new_task()
        end,
        mode = "n",
        desc = "task.seer=> new overseer task",
      },
      {
        key_overseer.bundle.list,
        function()
          require("overseer").list_task_bundles()
        end,
        mode = "n",
        desc = "task.seer=> list overseer task bundles",
      },
      {
        key_overseer.task.list,
        function()
          require("overseer").list_tasks()
        end,
        mode = "n",
        desc = "task.seer=> load overseer task bundle",
      },
      {
        key_overseer.bundle.load,
        function()
          require("overseer").load_task_bundle()
        end,
        mode = "n",
        desc = "task.seer=> load overseer task bundle",
      },
      {
        key_overseer.bundle.delete,
        function()
          require("overseer").delete_task_bundle()
        end,
        mode = "n",
        desc = "task.seer=> load overseer task bundle",
      },
      {
        key_overseer.run.template,
        function()
          require("overseer").run_template()
        end,
        mode = "n",
        desc = "task.seer=> run overseer template",
      },
      {
        key_overseer.run.action,
        function()
          require("overseer").run_action()
        end,
        mode = "n",
        desc = "task.seer=> run overseer action",
      },
    },
  },
  {
    "MarcHamamji/runner.nvim",
    cmd = { "Runner", "AutoRunner", "AutoRunnerStop" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    opts = {},
    config = function(_, opts)
      require("runner").setup(opts)
    end,
    keys = {
      {
        key_runner.run,
        function()
          require("runner").run()
        end,
        mode = "n",
        desc = "build.run=> run",
      },
      {
        key_runner.autorun.enable,
        function()
          require("runner").autorun()
        end,
        mode = "n",
        desc = "build.run=> enable autorun",
      },
      {
        key_runner.autorun.disable,
        function()
          require("runner").autorun_stop()
        end,
        mode = "n",
        desc = "build.run=> disable autorun",
      },
    },
  },
  {
    "nvimdev/rapid.nvim",
    cmd = { "Rapid" },
    opts = {},
    config = function(_, opts)
      require("rapid").setup(opts)
    end,
    keys = {
      {
        key_rapid,
        "<CMD>Rapid<CR>",
        mode = "n",
        desc = "build.rapid=> command",
      },
    },
  },
  {
    "dasupradyumna/launch.nvim",
    opts = {},
    config = function(_, opts)
      require("launch").setup(opts)
    end,
    keys = {
      {
        key_launch.task,
        "<CMD>LaunchTask<CR>",
        mode = "n",
        desc = "build.launch=> cwd tasks",
      },
      {
        key_launch.ft_task,
        "<CMD>LaunchTaskFT<CR>",
        mode = "n",
        desc = "build.launch=> filetype tasks",
      },
      {
        key_launch.config_show,
        "<CMD>LaunchShowTaskConfigs<CR>",
        mode = "n",
        desc = "build.launch=> all task configs",
      },
      {
        key_launch.ft_config_show,
        "<CMD>LaunchShowTaskConfigsFT<CR>",
        mode = "n",
        desc = "build.launch=> filetype task configs",
      },
      {
        key_launch.active,
        "<CMD>LaunchShowActiveTasks<CR>",
        mode = "n",
        desc = "build.launch=> cwd tasks",
      },
      {
        key_launch.debugger,
        "<CMD>LaunchDebugger<CR>",
        mode = "n",
        desc = "build.launch=> cwd debug configs",
      },
      {
        key_launch.ft_debugger,
        "<CMD>LaunchDebuggerFT<CR>",
        mode = "n",
        desc = "build.launch=> filetype debug configs",
      },
      {
        key_launch.config_debug,
        "<CMD>LaunchShowDebugConfigs<CR>",
        mode = "n",
        desc = "build.launch=> all debug configs",
      },
      {
        key_launch.ft_config_debug,
        "<CMD>LaunchShowDebugConfigsFT<CR>",
        mode = "n",
        desc = "build.launch=> show filetype debug configs",
      },
      {
        key_launch.config_edit,
        "<CMD>LaunchOpenConfigFile<CR>",
        mode = "n",
        desc = "build.launch=> open/edit current config",
      },
    },
  },
}
