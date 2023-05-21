local env = require("environment.ui")
local stems = require("environment.keys").stems
local mapn = require("environment.keys").mapn
local mapnv = require("environment.keys").mapnv

local key_pomodoro = stems.pomodoro
local key_easyread = stems.easyread
local key_ccc = stems.ccc
local key_glow = stems.glow
local key_cbox = stems.cbox
local key_cline = stems.cline

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
    init = function()
      mapn(
        key_pomodoro .. "p",
        "<CMD>PomodoroStart<CR>",
        { desc = "pomorg:>> start pomodoro timer" }
      )
      mapn(
        key_pomodoro .. "q",
        "<CMD>PomodoroStop<CR>",
        { desc = "pomorg:>> stop pomodoro timer" }
      )
      mapn(
        key_pomodoro .. "s",
        "<CMD>PomodoroStatus<CR>",
        { desc = "pomorg:>> pomodoro timer status" }
      )
    end,
    -- keys = require("environment.keys").pomodoro,
  },
  { "wakatime/vim-wakatime", event = "VeryLazy", enabled = true, lazy = false },
  {
    "nullchilly/fsread.nvim",
    cmd = { "FSRead", "FSClear", "FSToggle" },
    init = function()
      mapn(
        key_easyread,
        "<CMD>FSToggle<CR>",
        { desc = "bionic:>> toggle flow-state bionic reading" }
      )
    end,
    -- keys = require("environment.keys").easyread,
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = {
      "CccPick",
      "CccConvert",
      "CccHighlighterEnable",
      "CccHighlighterToggle",
    },
    init = function()
      mapn(
        key_ccc .. "c",
        "<CMD>CccPick<CR>",
        { desc = "ccc:>> pick color interface" }
      )
      mapn(
        key_ccc .. "h",
        "<CMD>CccHighlighterToggle<CR>",
        { desc = "ccc:>> toggle inline color highlighting" }
      )
      mapn(
        key_ccc .. "v",
        "<CMD>CccConvert<CR>",
        { desc = "ccc:>> convert color to another format" }
      )
      mapn(
        key_ccc .. "f",
        "<CMD>CccHighlighterDisable<CR>",
        { desc = "ccc:>> turn off inline color highlighting" }
      )
      mapn(
        key_ccc .. "o",
        "<CMD>CccHighlighterEnable<CR>",
        { desc = "ccc:>> turn on inline color highlighting" }
      )
    end,
    -- keys = require("environment.keys").ccc,
  },
  {
    -- <leader>i mappings for ASCII
    "pavanbhat1999/figlet.nvim",
    dependencies = { "numToStr/Comment.nvim" },
    cmd = {
      "Figlet",
      "Fig",
      "FigComment",
      "FigCommentHighlight",
      "FigList",
      "FigSelect",
      "FigSelectComment",
    },
    init = function()
      mapnv(
        stems.figlet .. "f",
        "<CMD>Figlet<CR>",
        { desc = "figlet:>> ascii interface" }
      )
      mapnv(
        stems.figlet .. "c",
        "<CMD>FigComment<CR>",
        { desc = "figlet:>> ascii comment interface" }
      )
      mapnv(
        stems.figlet .. "S",
        "<CMD>FigSelect<CR>",
        { desc = "figlet:>> ascii select interface" }
      )
      mapnv(
        stems.figlet .. "sc",
        "<CMD>FigSelectComment<CR>",
        { desc = "figlet:>> ascii select comment interface" }
      )
    end,
  },
  {
    "sudormrfbin/cheatsheet.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    init = function()
      mapn(
        "g/",
        require("telescope").extensions.cheatsheet.cheatsheet,
        { desc = "cheatsheet:>> cheatsheet interface" }
      )
    end,
  },
  {
    "ellisonleao/glow.nvim",
    opts = { border = env.borders.main, style = vim.env.CANDY_NVIM_MOOD },
    cmd = "Glow",
    ft = { "markdown", "mkd", "md", "rmd", "qmd" },
    init = function()
      mapn(
        key_glow,
        "<CMD>Glow!<CR>",
        { desc = "glow:>> glow markdown preview" }
      )
    end,
    -- keys = require("environment.keys").glow,
  },
  {
    "LudoPinelli/comment-box.nvim",
    event = "VeryLazy",
    opts = {
      doc_width = tonumber(vim.opt.textwidth:get()),
      box_width = (3 / 4) * tonumber(vim.opt.textwidth:get()),
    },
    init = function()
      mapnv(
        "<localleader>B",
        require("comment-box").catalog,
        { desc = "box:>> catalog" }
      )
      mapnv(key_cbox .. "ll", function()
        return require("comment-box").llbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉢 󱄽:󰉢" })

      mapnv(key_cbox .. "lc", function()
        return require("comment-box").lcbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉢 󱄽:󰉠" })

      mapnv(key_cbox .. "lr", function()
        return require("comment-box").lrbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉢 󱄽:󰉣" })

      mapnv(key_cbox .. "cl", function()
        return require("comment-box").clbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉠 󱄽:󰉢" })

      mapnv(key_cbox .. "cc", function()
        return require("comment-box").ccbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉠 󱄽:󰉠" })

      mapnv(key_cbox .. "cr", function()
        return require("comment-box").crbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉠 󱄽:󰉣" })

      mapnv(key_cbox .. "rl", function()
        return require("comment-box").rlbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉣 󱄽:󰉢" })

      mapnv(key_cbox .. "rc", function()
        return require("comment-box").rcbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉣 󱄽:󰉠" })

      mapnv(key_cbox .. "rr", function()
        return require("comment-box").rrbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰉣 󱄽:󰉣" })

      mapnv(key_cbox .. "al", function()
        return require("comment-box").albox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰡎 󱄽:󰉢" })

      mapnv(key_cbox .. "ac", function()
        return require("comment-box").acbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰡎 󱄽:󰉠" })

      mapnv(key_cbox .. "ar", function()
        return require("comment-box").arbox(vim.v.count)
      end, { desc = "box:>> 󰘷:󰡎 󱄽:󰉣" })
      mapnv(key_cline .. "l", function()
        return require("comment-box").line(vim.v.count)
      end, { desc = "line:>> 󰘷:󰡎 󱄽:󰉣" })
      mapnv(key_cline .. "c", function()
        return require("comment-box").cline(vim.v.count)
      end, { desc = "line:>> 󰘷:󰡎 󱄽:󰉣" })
      mapnv(key_cline .. "r", function()
        return require("comment-box").rline(vim.v.count)
      end, { desc = "line:>> 󰘷:󰡎 󱄽:󰉣" })
    end,
  },
  {
    "eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    init = function()
      mapn(
        "<leader>fml",
        "<CMD>CellularAutomaton make_it_rain<CR>",
        { desc = "here be automatous dragons [rainy]" }
      )
      mapn(
        "<leader>FML",
        "<CMD>CellularAutomaton make_it_rain<CR>",
        { desc = "here be automatous dragons [gamey]" }
      )
    end,
  },
  {
    "alec-gibson/nvim-tetris",
    cmd = "Tetris",
    config = function() end,
    init = function()
      mapn(
        "<localleader><bar>",
        "<CMD>Tetris<CR>",
        { desc = "tetris:>> play tetris" }
      )
    end,
  },
}
