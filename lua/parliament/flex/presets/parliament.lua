local M = {}

M.presets = {
  animation = {
    "SmoothCursor.nvim",
    "cinnamon.nvim",
  },
  alpha = {
    "dashboard.nvim",
    "veil.nvim",
    "fsplash.nvim",
  },
  editor = {
    "treesj",
    "mini.comment",
    "mini.surround",
    "mini.align",
    "mini.extra",
    "nvim-recorder",
    "auto-indent.nvim",
    "dial.nvim",
  },
  pairs = {
    "mini.pairs",
    "nvim-autopairs",
    "sentiment.nvim",
  },
  organization = {
    "neorg",
    "orgmode",
    "eureka",
  },
  organization_extras = {
    "headlines.nvim",
    "org-modern.nvim",
    "org-bullets.nvim",
    "telescope-orgmode.nvim",
  },
  neorg_extras = {
    "neorg-figlet-module",
    "neorg-templates",
    "neorg-jupyter",
    "neorg-exec",
  },
  time = {
    "due.nvim",
    "vim-wakatime",
    "usage-tracker.nvim",
    "pulse.nvim",
    "timewasted.nvim",
    "stand.nvim",
    "hydrate.nvim",
  },
  ai_passive = {
    "copilot.lua",
    "codeium.nvim",
    "tabnine-nvim",
    "cmp-tabnine",
    "huggingface/llm.nvim",
    "cmp-ai",
  },
  ai_activated = {
    "rgpt.nvim",
    "CodeGPT.nvim",
    "neural",
    "ChatGPT.nvim",
    "neoai.nvim",
    "naVi",
    "explain-it.nvim",
    "gsuuon/llm.nvim",
    "backseat.nvim",
    "wtf.nvim",
    "prompter.nvim",
    "aider.nvim",
    "juliusolson/gpt.nvim",
    "thmsmlr/gpt.nvim",
    "nvim-llama",
    "ollero.nvim",
    "gen.nvim",
  },
  buffers = {
    "mini.bufremove",
    "JABS.nvim",
    "cybu.nvim",
  },
  autoclose = {
    "nvim-early-retirement",
    "hbac.nvim",
  },
  windows = {
    "focus.nvim",
    "dressing.nvim",
    "colorful-winsep.nvim",
    "edgy.nvim",
    "help-vsplit.nvim",
    "stickybuf.nvim",
    "flatten.nvim",
    "ventana.nvim",
    "scope.nvim",
    "bufresize.nvim",
    "accordian.nvim",
  },
  lsp = {
    "nvim-lspconfig",
    "lsp-zero.nvim",
    "neoconf",
    "neodev",
    "mason.nvim",
    "mason-lspconfig.nvim",
  },
  lsp_extras = {
    "outline.nvim",
    "actions-preview.nvim",
    "output-panel.nvim",
    "lsp-toggle.nvim",
    "clear-action.nvim",
    "glance.nvim",
  },
  lint = {
    "nvim-lint",
    "mason-nvim-lint",
  },
  format = {
    "conform.nvim",
  },
  format_extras = {
    "pick-lsp-formatter.nvim",
    "nvim-rulebook",
  },
  cmp = {
    "nvim-cmp",
    "LuaSnip",
    "lsp-zero.nvim",
  },
  cmp_sources = {
    "cmp-nvim-lsp",
    "cmp-buffer",
    "cmp-path",
    "cmp-fuzzy-path",
    "cmp-cmdline",
    "cmp-nvim-lua",
    "cmp-nvim-lsp-signature-help",
    "cmp-nvim-lsp-document-symbol",
    "cmp-emoji",
    "cmp-git",
    "cmp-rg",
    "cmp-zsh",
    "cmp-ctags",
    "cmp-dap",
    "cmp-calc",
    "cmp-treesitter",
    "cmp-crates.nvim",
    "cmp-env",
    "cmp-color-names",
  },
  cmp_sources_extras = {
    "cmp-color-names",
    "cmp-pandoc=references",
    "nvim-cmp-fonts",
    "cmp-nerdfonts",
    "cmp-nerdfont",
    "cmp_luasnip",
    "cmp-plugins",
    "cmp-diag-codes",
    "cmp-dictionary",
    "cmp-spell",
    "cmp-tw2css",
    "cmp-gitlog",
    "cmp-latex-symbol",
    "cmp-natdat",
    "cmp-digraphs",
    "cmp-omni",
    "cmp-look",
  },
  snippet_sources = {
    "vim-snippets",
    "friendly-snippets",
    "telescope-luasnip.nvim",
  },
  build = {
    "executor.nvim",
    "compiler.nvim",
    "overseer.nvim",
    "runner.nvim",
    "rapid.nvim",
    "launch.nvim",
  },
  repl = {
    "vlime",
    "sniprun",
    "iron.nvim",
    "molten-nvim",
    "yarepl.nvim",
  },
  refactor = {
    "inc-rename.nvim",
    "ssr.nvim",
    "muren.nvim",
  },
  quickfix = {
    "nvim-bqf",
    "trouble.nvim",
  },
  debug = {
    "nvim-dap",
    "nvim-dap-ui",
    "mason-nvim-dap",
    "debugprint.nvim",
    "nvim-coverage",
    "printer.nvim",
  },
  dap_extras = {
    "nvim-dap-virtual-text",
    "nvim-dap-repl-highlights",
    "dap-utils.nvim",
    "dap-helper.nvim",
    "goto-breakpoints.nvim",
  },
  terminal = {
    "toggleterm.nvim",
  },
  fuzz = {
    "fzf-lua",
    "fzf",
    "fzf.vim",
  },
  telescope = {
    "telescope.nvim",
    "telescope-fzf-native",
  },
  telescope_extras = {
    "whaler.nvim",
    "telescope-tasks.nvim",
    "telescope-ports.nvim",
    "telescope-http.nvim",
    "telescope-find-pickers.nvim",
    "telescope-color-names.nvim",
    "telescope-cc.nvim",
    "telescope-undo.nvim",
    "telescope-media-files.nvim",
    "telescope-glyph.nvim",
    "telescope-symbols.nvim",
    "telescope-dap.nvim",
    "telescope-zoxide.nvim",
    "telescope-heading.nvim",
    "telescope-project.nvim",
    "telescope-menu.nvim",
    "telescope-lazy.nvim",
    "telescope-changes.nvim",
    "telescope-env.nvim",
    "telescope-repo.nvim",
    "telescope-file-browser.nvim",
    "telescope-env.nvim",
    "telescope-toggleterm.nvim",
  },
  env = {
    "direnv.vim",
    "dotenv.nvim",
  },
  folding = {
    "nvim-ufo",
    "foldhue.nvim",
    "pretty-fold.nvim",
    "promise-async",
    "nvim-origami",
    "nvim-foldsign",
  },
  ascii = {
    "comment-box.nvim",
    "nvim-comment-frame",
    "figban.nvim",
    "figlet.nvim",
    "venn.nvim",
  },
  icons = {
    "nerdy.nvim",
    "nerdicons.nvim",
    "icon-picker.nvim",
  },
  dates = {
    "dates.nvim",
    "nvim-relative-date",
  },
  huevos = {
    "cellular-automaton.nvim",
    "zone.nvim",
    "duck.nvim",
  },
  juegos = {
    "tetris",
    "sudoku",
    "blackjack",
    "killersheep",
    "nvimesweeper",
    "shenzhen-solitaire",
    "speedtyper.nvim",
  },
  miscellaneous = {
    "code-shot.nvim",
  },
  filesystem = {
    "neo-tree.nvim",
    "broot.nvim",
    "fm-nvim",
    "oil.nvim",
    "nnn.nvim",
    "attempt.nvim",
    "memento.nvim",
    "arena.nvim",
    "tfm.nvim",
  },
}

M.when_enabling = {}

return M
