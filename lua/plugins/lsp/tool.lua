local kenv = function(n)
  return require("environment.keys")[n]
end

local env = require("environment.ui")
local opt = require("environment.optional")
local key_action = kenv("action")
local key_view = kenv("view")
local key_lsp = kenv("lsp")
local key_ui = kenv("ui")
local key_oper = kenv("shortcut").operations

local mopts = require("funsak.table").mopts

return {
  {
    "junegunn/fzf",
  },
  {
    "junegunn/fzf.vim",
  },
  {
    "ojroques/nvim-lspfuzzy",
    event = "LspAttach",
    dependencies = {
      "junegunn/fzf",
      "junegunn/fzf.vim",
    },
    config = function(_, opts)
      require("lspfuzzy").setup(opts)
    end,
    opts = {
      methods = "all",
      jump_one = true,
      save_last = true,
      fzf_trim = true,
      fzf_modifier = ":~:.",
    },
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function(_, opts)
      vim.diagnostic.config(opts)
    end,
    enabled = opt.lsp.diagnostics.lsp_lines.enable,
    event = "LspAttach",
    opts = {
      virtual_lines = {
        virtual_lines = true,
        only_current_line = true,
      },
    },
    keys = {
      {
        key_ui.diagnostics.toggle_lines,
        function()
          require("lsp_lines").toggle()
        end,
        mode = "n",
        desc = "lsp.diag=> toggle ex-lines",
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    enabled = opt.symbol.aerial.enable,
    opts = {
      layout = {
        max_width = { 36, 0.2 },
        min_width = 12,
      },
      open_automatic = false,
      keymaps = {
        ["?"] = "actions.show_help",
        ["gh"] = "actions.show_help",
        ["<cr>"] = "actions.jump",
        ["<2-leftmouse>"] = "actions.jump",
        ["<c-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["p"] = "actions.scroll",
        ["<C-d>"] = "actions.down_and_scroll",
        ["<C-u>"] = "actions.up_and_scroll",
        ["{"] = "actions.prev",
        ["}"] = "actions.next",
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        ["Q"] = "actions.close",
        ["o"] = "actions.tree_toggle",
        ["za"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["zA"] = "actions.tree_toggle_recursive",
        ["l"] = "actions.tree_open",
        ["zo"] = "actions.tree_open",
        ["L"] = "actions.tree_open_recursive",
        ["zO"] = "actions.tree_open_recursive",
        ["h"] = "actions.tree_close",
        ["zc"] = "actions.tree_close",
        ["H"] = "actions.tree_close_recursive",
        ["zC"] = "actions.tree_close_recursive",
        ["zr"] = "actions.tree_increase_fold_level",
        ["zR"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zM"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = "actions.tree_sync_folds",
      },
      filter_kind = false,
      show_guides = true,
      guides = {
        mid_item = "╠",
        last_item = "╚",
        nested_top = "║",
        whitespace = " ",
      },
      highlight_on_hover = true,
      highlight_on_jump = 800,
      autojump = true,
      ignore = {
        filetypes = env.ft_ignore_list,
      },
      float = {
        border = env.borders.main,
        relative = "cursor",
        max_height = 0.8,
        min_height = { 12, 0.1 },
      },
      nav = {
        border = env.borders.main,
        max_height = 0.8,
        min_height = { 12, 0.1 },
        max_width = 0.6,
        min_width = { 0.2, 24 },
        autojump = true,
        preview = true,
      },
    },
    config = function(_, opts)
      require("aerial").setup(opts)
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "AerialToggle",
      "AerialOpen",
      "AerialOpenAll",
      "AerialInfo",
      "AerialNavToggle",
      "AerialNavOpen",
    },
    keys = {
      {
        key_view.aerial.toggle,
        "<CMD>AerialToggle<CR>",
        mode = "n",
        desc = "symbol.aerial=> toggle",
      },
      {
        key_view.aerial.close,
        "<CMD>AerialClose<CR>",
        mode = "n",
        desc = "symbol.aerial=> close",
      },
      {
        key_view.aerial.open,
        "<CMD>AerialOpen<CR>",
        mode = "n",
        desc = "symbol.aerial=> open ",
      },
      {
        key_view.aerial.force.toggle,
        "<CMD>AerialToggle<CR>",
        mode = "n",
        desc = "symbol.aerial=> toggle[!]",
      },
      {
        key_view.aerial.force.close,
        "<CMD>AerialClose<CR>",
        mode = "n",
        desc = "symbol.aerial=> close[!]",
      },
      {
        key_view.aerial.force.open,
        "<CMD>AerialOpen<CR>",
        mode = "n",
        desc = "symbol.aerial=> open[!]",
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    enabled = opt.symbol.outline.enable,
    cmd = { "Outline", "OutlineOpen", "OutlineClose" },
    opts = {
      outline_window = {
        position = "right",
        split_command = nil,
        width = 20,
        relative_width = true,
        auto_close = false,
        auto_jump = true,
        show_cursorline = true,
        show_relative_numbers = false,
        show_numbers = true,
        wrap = false,
        winhl = "OutlineDetails:Comment,OutlineLineno:LineNr",
      },
      outline_items = {
        highlight_hovered_item = true,
        show_symbol_details = true,
        show_symbol_lineno = true,
      },
      guides = {
        enabled = true,
        markers = {
          bottom = "",
          middle = "",
          vertical = "",
        },
      },
      symbol_folding = {
        autofold_depth = nil,
        auto_unfold_hover = true,
        markers = { "", "" },
      },
      preview_window = {
        auto_preview = false,
        open_hover_on_preview = true,
        width = 64,
        min_width = 50,
        relative_width = true,
        border = env.borders.main,
        winhl = "",
        winblend = 20,
      },
      keymaps = {
        code_actions = { "a", "ga", "<leader>a" },
        close = { key_view:close() },
        toggle_preview = "<C-p>",
        hover_symbol = "K",
        rename_symbol = "r",
        focus_location = "o",
        fold = "h",
        unfold = "l",
        fold_all = "zM",
        unfold_all = "zR",
        fold_reset = "zW",
      },
    },
    config = function(_, opts)
      require("outline").setup(opts)
    end,
    keys = {
      {
        key_view.symbols_outline.toggle,
        "<CMD>Outline<CR>",
        mode = "n",
        desc = "symbol.outline=> toggle",
      },
      {
        key_view.symbols_outline.close,
        "<CMD>OutlineClose<CR>",
        mode = "n",
        desc = "symbol.outline=> close",
      },
      {
        key_view.symbols_outline.open,
        "<CMD>OutlineOpen<CR>",
        mode = "n",
        desc = "symbol.outline=> open",
      },
    },
  },
  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      enable = true,
      include_declaration = false,
      sections = {
        definition = function(count)
          return "def#󰡱 : " .. count
        end,
        references = function(count)
          return "ref#󰡱 : " .. count
        end,
        implements = function(count)
          return "imp#󰡱 : " .. count
        end,
      },
      ignore_filetype = env.ft_ignore_list,
    },
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    keys = {
      {
        key_view.lens.toggle,
        "<CMD>LspLensToggle<CR>",
        mode = { "n" },
        desc = "lsp.lens=> toggle",
      },
      {
        key_view.lens.on,
        "<CMD>LspLensOn<CR>",
        mode = { "n" },
        desc = "lsp.lens=> on",
      },
      {
        key_view.lens.off,
        "<CMD>LspLensOff<CR>",
        mode = { "n" },
        desc = "lsp.lens=> off",
      },
    },
  },
  {
    "echasnovski/mini.operators",
    event = "VeryLazy",
    version = false,
    config = function(_, opts)
      require("mini.operators").setup(opts)
    end,
    opts = {
      evaluate = {
        prefix = key_oper.evaluate,
      },
      exchange = {
        prefix = key_oper.exchange,
      },
      multiply = {
        prefix = key_oper.multiply,
      },
      replace = {
        prefix = key_oper.replace,
      },
      sort = {
        prefix = key_oper.sort,
      },
    },
  },
  -- {
  --   "ivanjermakov/troublesum.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     enabled = true,
  --     autocmd = true,
  --     severity_format = {
  --       env.icons.diagnostic.Error,
  --       env.icons.diagnostic.Warn,
  --       env.icons.diagnostic.Info,
  --       env.icons.diagnostic.Hint,
  --     },
  --     format = function(counts) end,
  --     display_summary = function(bufnr, ns, text) end,
  --   },
  --   config = function(_, opts)
  --     require("troublesum").setup(opts)
  --   end,
  -- },
  {
    "aznhe21/actions-preview.nvim",
    opts = {
      diff = {
        ctxlen = 3,
      },
      nui = {
        preview = {
          border = { style = env.borders.main, padding = { 1, 2 } },
        },
        select = {
          border = { style = env.borders.main, padding = { 1, 2 } },
        },
      },
    },
    config = function(_, opts)
      require("actions-preview").setup(opts)
    end,
    keys = {
      {
        key_action.preview,
        function()
          require("actions-preview").code_actions()
        end,
        mode = { "v", "n" },
        desc = "lsp=> preview code actions",
      },
    },
  },
  {
    "mhanberg/output-panel.nvim",
    cmd = { "OutputPanel" },
    config = function(_, opts)
      require("output_panel").setup(opts)
    end,
    keys = {
      {
        key_lsp.auxillary.output_panel,
        "<CMD>OutputPanel<CR>",
        mode = "n",
        desc = "lsp=> toggle log panel",
      },
    },
  },
  {
    "adoyle-h/lsp-toggle.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    opts = { create_cmds = true, telescope = true },
    config = true,
    keys = {
      {
        key_lsp.auxillary.toggle.server,
        "<CMD>ToggleLSP<CR>",
        mode = "n",
        desc = "lsp=> toggle buffer server",
      },
      {
        key_lsp.auxillary.toggle.nullls,
        "<CMD>ToggleNullLSP<CR>",
        mode = "n",
        desc = "lsp=> toggle buffer null-ls",
      },
    },
  },
  {
    "hinell/lsp-timeout.nvim",
    event = "LspAttach",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    init = function()
      vim.g.lspTimeoutConfig = {
        stopTimeout = 1000 * 60 * 5,
        startTimeout = 1000 * 60 * 1,
        silent = false,
      }
    end,
  },
  {
    "luckasRanarison/clear-action.nvim",
    opts = {
      silent = false,
      signs = {
        enable = true,
        position = "overlay",
        separator = " ",
        show_count = true,
        show_label = true,
        update_on_insert = false,
        icons = env.icons.actions,
      },
      popup = {
        enable = true,
        center = false,
        border = env.borders.main,
        hide_cursor = false,
      },
      mappings = {
        code_action = { key_action.code_action, "action=> code actions" },
        apply_first = { key_action.apply_first, "action=> apply first action" },
        quickfix = { key_action.quickfix.quickfix, "action.qf=> quickfix" },
        quickfix_next = { key_action.quickfix.next, "action.qf=> next" },
        quickfix_prev = { key_action.quickfix.prev, "action.qf=> previous" },
        refactor = { key_action.refactor.refactor, "action.rf=> refactor" },
        refactor_inline = { key_action.refactor.inline, "action.rf=> inline" },
        refactor_extract = {
          key_action.refactor.extract,
          "action.rf=> extract",
        },
        refactor_rewrite = {
          key_action.refactor.rewrite,
          "action.rf=> rewrite",
        },
        source = { key_action.source, "action=> source" },
      },
    },
    config = function(_, opts)
      require("clear-action").setup(opts)
    end,
    keys = {
      {
        key_ui.signs.actions.toggle,
        "<CMD>CodeActionToggleSigns<CR>",
        mode = "n",
        desc = "ui.action=> toggle signs",
      },
      {
        key_ui.signs.actions.toggle_label,
        "<CMD>CodeActionToggleLabel<CR>",
        mode = "n",
        desc = "ui.action=> toggle labels",
      },
    },
  },
  {
    "JMarkin/gentags.lua",
    enabled = false,
    event = "VeryLazy",
    cond = vim.fn.executable("ctags") == 1,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function(_, opts)
      local Path = require("plenary.path")
      opts = opts or {}
      opts.cache = opts.cache or {}
      opts.cache.path = Path:new(vim.fn.stdpath(opts.cache.path or "cache"))
      require("gentags").setup(opts)
    end,
    opts = {
      root_dir = vim.g.gentags_root_dir or vim.loop.cwd(),
      bin = "ctags",
      cache = {
        path = "cache",
      },
      args = { -- extra args
        "--extras=+r+q",
        "--exclude=.git",
        "--exclude=node_modules*",
        "--exclude=.mypy*",
        "--exclude=.pytest*",
        "--exclude=.ruff*",
        "--exclude=BUILD",
        "--exclude=vendor*",
        "--exclude=*.min.*",
      },
      -- mapping ctags --languages <-> neovim filetypes
      lang_ft_map = {
        ["Python"] = { "python" },
        ["Lua"] = { "lua" },
        ["Vim"] = { "vim" },
        ["C,C++,CUDA"] = { "c", "cpp", "h", "cuda" },
        ["JavaScript"] = { "javascript" },
        ["Go"] = { "go" },
      },
    },
  },
  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    opts = function(_, opts)
      local actions = require("glance").actions
      opts.height = opts.height or 16 -- Height of the window
      opts.zindex = opts.zindex or 45
      -- Or use a function to enable `detached` only when the active window is too small
      -- (default behavior)
      opts.detached = opts.detached
        or function(winid)
          return vim.api.nvim_win_get_width(winid) < 100
        end

      opts.preview_win_opts = mopts({
        -- Configure preview window
        cursorline = true,
        number = true,
        wrap = true,
      }, opts.preview_win_opts)
      opts.border = mopts({
        -- Show window borders. Only horizontal borders allowed
        enable = true,
        top_char = "🮦",
        bottom_char = "🮧",
      }, opts.border)
      opts.list = mopts({
        -- Position of the list window 'left'|'right'
        position = "right",
        -- 33% width relative to the active window, min 0.1, max 0.5
        width = 0.32,
      }, opts.list)
      -- This feature might not work properly in nvim-0.7.2
      opts.theme = mopts({
        -- Will generate colors for the plugin based on your current colorscheme
        enable = true,
        -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
        mode = "auto",
      }, opts.theme)
      opts.mappings = mopts({
        list = {
          -- Bring the cursor to the next item in the list
          ["j"] = actions.next,
          -- Bring the cursor to the previous item in the list
          ["k"] = actions.previous,
          ["<Down>"] = actions.next,
          ["<Up>"] = actions.previous,
          -- Bring the cursor to the next location skipping groups in the list
          ["<Tab>"] = actions.next_location,
          -- Bring the cursor to the previous location skipping groups in the list
          ["<S-Tab>"] = actions.previous_location,
          ["<C-u>"] = actions.preview_scroll_win(5),
          ["<C-d>"] = actions.preview_scroll_win(-5),
          ["v"] = actions.jump_vsplit,
          ["s"] = actions.jump_split,
          ["t"] = actions.jump_tab,
          ["<CR>"] = actions.jump,
          ["o"] = actions.jump,
          ["l"] = actions.open_fold,
          ["h"] = actions.close_fold,
          -- Focus preview window
          ["<leader>l"] = actions.enter_win("preview"),
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<C-q>"] = actions.quickfix,
        },
        preview = {
          ["q"] = actions.close,
          ["Q"] = actions.close,
          ["<Esc>"] = actions.close,
          ["<Tab>"] = actions.next_location,
          ["<S-Tab>"] = actions.previous_location,
          -- Focus list window
          ["<leader>l"] = actions.enter_win("list"),
        },
      }, opts.mapping)
      opts.hooks = mopts({}, opts.hooks)
      opts.folds = mopts({
        fold_closed = "⌐",
        fold_open = "⌙",
        -- Automatically fold list on startup
        folded = true,
      }, opts.folds)
      opts.indent_lines = mopts({
        enable = true,
        icon = "│",
      }, opts.indent_lines)
      opts.winbar = mopts({
        -- Available starting from nvim-0.8+
        enable = true,
      }, opts.winbar)
    end,
    keys = {
      {
        key_lsp.go.glance.references,
        "<CMD>Glance references<CR>",
        mode = "n",
        desc = "glance=> references",
      },
      {
        key_lsp.go.glance.definition,
        "<CMD>Glance definitions<CR>",
        mode = "n",
        desc = "glance=> definitions",
      },
      {
        key_lsp.go.glance.type_definition,
        "<CMD>Glance type_definitions<CR>",
        mode = "n",
        desc = "glance=> type definitions",
      },
      {
        key_lsp.go.glance.implementation,
        "<CMD>Glance implementations<CR>",
        mode = "n",
        desc = "glance=> implementations",
      },
    },
  },
  {
    "Wansmer/symbol-usage.nvim",
    enabled = false,
    event = "BufReadPre",
    config = function(_, opts)
      require("symbol-usage").setup(opts)
    end,
    opts = {
      hl = { link = "Comment" },
      kinds = {
        vim.lsp.protocol.SymbolKind.Function,
        vim.lsp.protocol.SymbolKind.Method,
      },
      vt_position = "textwidth",
      references = { enabled = true, include_declaration = true },
      definition = { enabled = true },
      implementation = { enabled = true },
    },
  },
}
