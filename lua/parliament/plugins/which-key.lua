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
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
        spelling = {
          enabled = true,
          suggestions = 20,
        },
      },
      operators = {
        gc = "Comments",
        qc = "Qortal: Changelist",
        qh = "Qortal: Harpoon",
        qq = "Qortal: Quickfix",
        qg = "Qortal: Grapple",
        qj = "Qortal: Jumplist",
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
        "g'",
        "\"", -- registers,
        "<c-r>", -- spelling
        "z=",
        "Z",
        "<C-Space>",
        "qc",
        "qg",
        "qh",
        "qj",
        "qq",
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
      icons = { breadcrumb = "󰶻", separator = "⦒", group = " " },
      defaults = {
        [stems:leader()] = { name = "::| toolbox |::" },
        [stems.time:leader()] = { name = "::| task/time |::" },
        [stems.ai:leader()] = { name = "::| ai/assistants |::" },
        [stems.repl:leader()] = { name = "::| repl |::" },
        [stems.repl.molten:leader()] = { name = "::| molten#repl |::" },
        [stems.repl.jupyter:leader()] = { name = "::| jupyter#repl |::" },
        [stems.repl.yarepl:leader()] = { name = "::| molten#repl |::" },
        [stems.repl.iron:leader()] = { name = "::| molten#repl |::" },
        [stems.buffer:leader()] = { name = "::| buffers |::" },
        [stems.search:leader()] = { name = "::| search/scope |::" },
        [stems.ui:leader()] = { name = "::| interface |::" },
        [stems.action:leader()] = { name = "::| code#action |::" },
        [stems.test:leader()] = { name = "::| test |::" },
        [stems.fuzz:leader()] = { name = "::| fz |::" },
        [stems.fm:leader()] = { name = "::| filesystem |::" },
        [stems.view:leader()] = { name = "::| viewers |::" },
        [stems.scope:leader()] = { name = "::| telescope |::" },
        [stems.window:leader()] = { name = "::| windows |::" },
        [stems.motion:leader()] = { name = "::| move/goto |::" },
        [stems.lazy:leader()] = { name = "::| lazy |::" },
        [stems.lang:leader()] = { name = "::| langdef |::" },
        [stems.color:leader()] = { name = "::| colors |::" },
        [stems.build:leader()] = { name = "::| build/run |::" },
        [stems.debug:leader()] = { name = "::| debug |::" },
        [stems.git:leader()] = { name = "::| git |::" },
        [stems.mail:leader()] = { name = "::| mail |::" },
        [stems.docs:leader()] = { name = "::| docs |::" },
        [stems.search:leader()] = { name = "::| search |::" },
        [stems.replace:leader()] = { name = "::| replace |::" },
        [stems.macro:leader()] = { name = "::| macros |::" },
        [stems.term:leader()] = { name = "::| utiliterm |::" },
        [stems.shortcut.fm.explore:leader()] = { name = "::| explore |::" },
        [stems.session:leader()] = { name = "::| session |::" },
        [stems.tool.rest:leader()] = { name = "::| REST |::" },
        [stems.tool.regex:leader()] = { name = "::| regex |::" },
        [stems.tool.splitjoin:leader()] = { name = "::| split/join |::" },
        [stems.yank:leader()] = { name = "::| yank |::" },
        [stems.lsp.workspace:leader()] = { name = "::| workspace |::" },
        [stems.diagnostic:leader()] = { name = "::| diag/trouble |::" },
        [stems.lists:leader()] = { name = "::| lists |::" },
        [stems.lists.quickfix:leader()] = { name = "::| lists#qf |::" },
        [stems.lists.loclist:leader()] = { name = "::| lists#loc |::" },
        [stems.newts:leader()] = { name = "::| notice |::" },
        [stems.help:leader()] = { name = "::| help |::" },
        [stems.tab:leader()] = { name = "::| tab |::" },
        [stems.tool.snippet:leader()] = { name = "::| snippet |::" },
        [stems.editor:leader()] = { name = "::| editor |::" },
        [stems.editor.notes:leader()] = { name = "::| notes |::" },
        [stems.editor.figlet:leader()] = { name = "::| figlet |::" },
        [stems.editor.cbox:leader()] = { name = "::| commentbox |::" },
        [stems.editor.cline:leader()] = { name = "::| commentbox |::" },
        [stems.editor.licenses:leader()] = { name = "::| license |::" },
        [stems.editor.glyph:leader()] = { name = "::| glyph |::" },
        [stems.editor.template:leader()] = { name = "::| templates |::" },
        [stems.editor.wrapping:leader()] = { name = "::| wrapping |::" },
        [stems.editor.workspaces:leader()] = { name = "::| workspaces |::" },
        -- TODO: create and implement a system which can more appropriately
        -- handle the creation and specifically merging of labels that are
        -- specified in multiple places. This arises when there are plugin
        -- bindings that are similar enough to fall under the same family but
        -- which conflict against each other in that their leader keys are the
        -- same. e.g. <localleader> is technically the leader for "time" but
        -- with the below is marked for neorg
        -- NOTE: This can and probably should be implemented on the keybundling
        -- system directly. This is because such an implementation would be
        -- easily callable from the location where maps are defined per plugin
        -- to inline define the which-key labelings
        [stems.time.stand:leader()] = { name = "::| stand |::" },
        [stems.time.pomodoro:leader()] = { name = "::| timers |::" },
        [stems.time.pulse:leader()] = { name = "::| timers |::" },
        [stems.time.neorg.notes:leader()] = { name = "::| notes#norg |::" },
        [stems.time.neorg.journal:leader()] = { name = "::| journal#norg |::" },
        [stems.time.neorg.linkable:leader()] = { name = "::| links#norg |::" },
        [stems.time.neorg.metagen:leader()] = { name = "::| metadata#norg |::" },
        [stems.time.neorg.workspace:leader()] = {
          name = "::| workspaces#norg |::",
        },
        [stems.time.neorg.dt:leader()] = { name = "::| dt#norg |::" },
        [stems.time.neorg.export:leader()] = { name = "::| export#norg |::" },
        [stems.time.dates:leader()] = { name = "::| dt |::" },
        [stems.time.oogway:leader()] = { name = "::| oogway |::" },
        [stems.lsp:leader()] = { name = "::| code/lsp |::" },
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
    config = function(_, opts)
      require("which-key").setup(opts)
      require("which-key").register(opts.defaults)
    end,
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
  {
    "tris203/hawtkeys.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("hawtkeys").setup(opts)
    end,
  },
}
