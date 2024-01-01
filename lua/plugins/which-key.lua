-- vim: set ft=lua: -0-
local env = require("environment.ui")
local stems = require("environment.keys")

return {
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        marks = false,
        registers = true,
      },
      hidden = {
        "<silent>",
        "<cmd>",
        "<Cmd>",
        "<CR>",
        "^ ",
        "^call ",
        "^lua ",
      }, -- hide mapping boilerplate
      window = {
        border = env.borders.main,
        position = "top",
        winblend = 25,
        zindex = 100,
      },
      key_labels = {
        ["<space>"] = "󱁐",
        ["<shift>"] = "󰘶",
        ["<ctrl>"] = "⌃",
        ["<alt>"] = "⎇",
        ["<meta>"] = "⎇",
        ["<tab>"] = "󰌒",
        ["<bs>"] = "⌫",
        ["<pageup>"] = "⎗",
        ["<pagedown>"] = "⎘",
        ["<home>"] = "⇱",
        ["<end>"] = "⇲",
        ["<CR>"] = "↵",
        ["<F1>"] = "󱊫",
        ["<F2>"] = "󱊬",
        ["<F3>"] = "󱊭",
        ["<F4>"] = "󱊮",
        ["<F5>"] = "󱊯",
        ["<F6>"] = "󱊰",
        ["<F7>"] = "󱊱",
        ["<F8>"] = "󱊲",
        ["<F9>"] = "󱊳",
        ["<F10>"] = "󱊴",
        ["<F11>"] = "󱊵",
        ["<F12>"] = "󱊶",
      },
      triggers_nowait = {
        "gc",
        "gz",
        "g`",
        "g'", -- registers '"',
        "<c-r>",
        -- spelling
        "z=",
        "Z",
        "qc",
        "qq",
        "qg",
      },
      documentation = {
        view = "hover",
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
      icons = {
        breadcrumb = "󰶻",
        separator = "",
        group = " ",
      },
      defaults = {
        [stems:leader()] = { name = "::| toolbox |::" },
        [stems.editor:leader()] = { name = "::| special/editor |::" },
        [stems.time:leader()] = { name = "::| task/time |::" },
        [stems.ai:leader()] = { name = "::| ai/assistants |::" },
        [stems.repl:leader()] = { name = "::| repl |::" },
        [stems.buffer:leader()] = { name = "::| buffers |::" },
        [stems.search:leader()] = { name = "::| search/scope |::" },
        [stems.ui:leader()] = { name = "::| interface |::" },
        [stems.code:leader()] = { name = "::| code |::" },
        [stems.lsp:leader()] = { name = "::| language servers |::" },
        [stems.fuzz:leader()] = { name = "::| fuzzy find |::" },
        [stems.fm:leader()] = { name = "::| filesystem |::" },
        [stems.view:leader()] = { name = "::| viewers |::" },
        [stems.scope:leader()] = { name = "::| telescope |::" },
        [stems.window:leader()] = { name = "::| windows |::" },
        [stems.motion:leader()] = { name = "::| move/goto |::" },
        [stems.lazy:leader()] = { name = "::| lazy |::" },
        [stems.lang:leader()] = { name = "::| languages |::" },
        [stems.color:leader()] = { name = "::| colors |::" },
        [stems.build:leader()] = { name = "::| build/run |::" },
        [stems.repl:leader()] = { name = "::| repl |::" },
        [stems.debug:leader()] = { name = "::| debug |::" },
        [stems.git:leader()] = { name = "::| git |::" },
        [stems.mail:leader()] = { name = "::| mail |::" },
        [stems.docs:leader()] = { name = "::| documentation |::" },
        [stems.search:leader()] = { name = "::| search |::" },
        [stems.action:leader()] = { name = "::| action |::" },
        [stems.replace:leader()] = { name = "::| replace |::" },
        [stems.macro:leader()] = { name = "::| macros |::" },
        [stems.term:leader()] = { name = "::| utiliterm |::" },
        [stems.shortcut.fm.explore:leader()] = { name = "::| explore |::" },
        [stems.multicursor:leader()] = { name = "::| multiline |::" },
        [stems.session:leader()] = { name = "::| session |::" },
        [stems.tool.rest:leader()] = { name = "::| REST |::" },
        [stems.tool.regex:leader()] = { name = "::| regex |::" },
        [stems.tool.splitjoin:leader()] = { name = "::| splitjoin |::" },
        [stems.yank:leader()] = { name = "::| yank |::" },
        [stems.lsp.workspace:leader()] = { name = "::| workspace |::" },
        [stems.diagnostic:leader()] = { name = "::| diag/trouble |::" },
      },
    },
    keys = {
      {
        "<C-g>h",
        "<CMD>WhichKey '' i<CR>",
        mode = { "n", "i" },
        desc = "which=> key help",
      },
    },
  },
  {
    "jokajak/keyseer.nvim",
    opts = {},
    config = function(_, opts)
      require("keyseer").setup(opts)
    end,
    version = false,
    keys = {
      {
        stems.view.keyseer,
        "<CMD>KeySeer<CR>",
        mode = "n",
        desc = "seer=> keys mapped",
      },
    },
    cmd = "KeySeer",
  },
}
