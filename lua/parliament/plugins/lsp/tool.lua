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
local key_scope = kenv("scope")

local mopts = require("funsak.table").mopts
local comp = require("funsak.colors").component

return {
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function(_, opts)
      vim.diagnostic.config(opts)
    end,
    event = "LspAttach",
    opts = { virtual_lines = { only_current_line = false } },
    keys = {
      {
        key_view.diagnostic.lsp_lines.toggle,
        function()
          require("lsp_lines").toggle()
        end,
        mode = "n",
        desc = "lsp.diag=> toggle ex-lines",
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    enabled = opt.symbol.outline and opt.prefer.symbol_outline == "outline",
    cmd = { "Outline", "OutlineOpen", "OutlineClose" },
    opts = {
      outline_window = {
        position = "left",
        split_command = nil,
        width = 14,
        relative_width = true,
        auto_close = false,
        auto_jump = true,
        show_cursorline = true,
        show_relative_numbers = false,
        show_numbers = false,
        wrap = true,
        winhl = "OutlineDetails:Comment,OutlineLineno:LineNr",
      },
      outline_items = {
        highlight_hovered_item = true,
        show_symbol_details = true,
        show_symbol_lineno = true,
      },
      guides = {
        enabled = true,
        markers = { bottom = "┖", middle = "╹", vertical = "┊" },
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
        toggle_preview = "P",
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
      evaluate = { prefix = key_oper.evaluate },
      exchange = { prefix = key_oper.exchange },
      multiply = { prefix = key_oper.multiply },
      replace = { prefix = key_oper.replace },
      sort = { prefix = key_oper.sort },
    },
  },
  {
    "aznhe21/actions-preview.nvim",
    opts = {
      diff = { ctxlen = 3 },
      telescope = vim.tbl_extend(
        "force",
        require("telescope.themes").get_dropdown(),
        {
          make_value = nil,
          make_make_display = nil,
        }
      ),
      nui = {
        preview = {
          size = "64%",
          border = { style = env.borders.main, padding = { 1, 2 } },
        },
        select = {
          size = "36%",
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
    config = function(_, opts)
      require("output_panel").setup(opts)
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "outputpanel",
        callback = function(ev)
          vim.keymap.set("n", "q", function()
            vim.cmd([[close]])
          end, { desc = "lsp.log=> close panel", buffer = ev.buf })
        end,
      })
    end,
    opts = {},
    event = "LspAttach",
    keys = {
      {
        key_lsp.auxiliary.output_panel,
        "<CMD>OutputPanel<CR>",
        mode = "n",
        desc = "lsp.log=> panel",
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
        key_lsp.auxiliary.toggle.server,
        "<CMD>ToggleLSP<CR>",
        mode = "n",
        desc = "lsp=> toggle buffer server",
      },
      {
        key_lsp.auxiliary.toggle.nullls,
        "<CMD>ToggleNullLSP<CR>",
        mode = "n",
        desc = "lsp=> toggle buffer null-ls",
      },
    },
  },
  {
    "luckasRanarison/clear-action.nvim",
    event = "LspAttach",
    opts = {
      silent = false,
      signs = {
        enable = true,
        position = "eol",
        separator = " ",
        show_count = true,
        show_label = true,
        update_on_insert = false,
        icons = env.icons.actions,
      },
      popup = {
        enable = true,
        center = false,
        border = env.borders.alt,
        hide_cursor = true,
      },
      mappings = {
        code_action = { key_action.code_action, "action=> code actions" },
        apply_first = {
          key_action.apply_first,
          "action=> apply first action",
        },
        quickfix = {
          key_action.quickfix.quickfix,
          "action.qf=> quickfix",
        },
        quickfix_next = { key_action.quickfix.next, "action.qf=> next" },
        quickfix_prev = {
          key_action.quickfix.prev,
          "action.qf=> previous",
        },
        refactor = {
          key_action.refactor.refactor,
          "action.rf=> refactor",
        },
        refactor_inline = {
          key_action.refactor.inline,
          "action.rf=> inline",
        },
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
      opts.indent_lines =
          mopts({ enable = true, icon = "│" }, opts.indent_lines)
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
    "kosayoda/nvim-lightbulb",
    config = function(_, opts)
      require("nvim-lightbulb").setup(opts)
    end,
    opts = {
      autocmd = { enabled = true },
      ignore = { ft = env.ft_ignore_list },
      sign = { enabled = true, text = "󰸊" },
    },
    event = "LspAttach",
  },
  {
    "onsails/diaglist.nvim",
    opts = { debug = false, debounce_ms = 300 },
    config = function(_, opts)
      require("diaglist").init(opts)
    end,
    event = "LspAttach",
    keys = {
      {
        key_view.diagnostic.diaglist.workspace,
        function()
          require("diaglist").open_all_diagnostics()
        end,
        mode = "n",
        desc = "lsp.diag=> list all",
      },
      {
        key_view.diagnostic.diaglist.buffer,
        function()
          require("diaglist").open_buffer_diagnostics()
        end,
        mode = "n",
        desc = "lsp.diag=> list buffer",
      },
    },
  },
  {
    "bbjornstad/corn.nvim",
    config = function(_, opts)
      require("corn").setup(opts)
    end,
    opts = {
      auto_cmds = true,
      sort_method = "severity",
      scope = "line",
      highlights = {
        error = "DiagnosticFloatingError",
        warn = "DiagnosticFloatingWarn",
        info = "DiagnosticFloatingInfo",
        hint = "DiagnosticFloatingHint",
      },
      icons = {
        error = env.icons.diagnostic.Error,
        warn = env.icons.diagnostic.Warn,
        info = env.icons.diagnostic.Info,
        hint = env.icons.diagnostic.Hint,
      },
      on_toggle = function(is_hidden)
        vim.diagnostic.config({
          virtual_text = not vim.diagnostic.config().virtual_text,
        })
      end,
      item_preprocess_func = function(item)
        return item
      end,
      window_opts = function()
        return {
          border = env.borders.alt,
          anchor = "SE",
          relative = "win",
          zindex = 100,
          title = "lsp::diagnostic",
          title_pos = "right",
          row = 0.96 * vim.api.nvim_win_get_height(0),
          col = 0.98 * vim.api.nvim_win_get_width(0),
        }
      end,
    },
    event = "LspAttach",
  },
  {
    "chikko80/error-lens.nvim",
    enabled = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = function(_, opts)
      local error = comp("DiagnosticSignError", { "fg", "bg" })
      local warn = comp("DiagnosticSignWarn", { "fg", "bg" })
      local info = comp("DiagnosticSignInfo", { "fg", "bg" })
      local hint = comp("DiagnosticSignHint", { "fg", "bg" })
      local fb = comp("FloatBorder", { "bg" })

      return {
        enabled = false,
        auto_adjust = {
          enable = true,
          fallback_bg_color = "#2a2a37",
          step = 7,
          total = 40,
        },
        prefix = 4,
        colors = {
          error_fg = error.fg,
          error_bg = error.bg,
          warn_fg = warn.fg,
          warn_bg = warn.bg,
          info_fg = info.fg,
          info_bg = info.bg,
          hint_fg = hint.fg,
          hint_bg = hint.bg,
        },
      }
    end,
    config = function(_, opts)
      require("error-lens").setup(opts)
    end,
    keys = {
      {
        key_view.diagnostic.error_lens.toggle,
        function()
          require("error-lens").toggle()
        end,
        mode = "n",
        desc = "lsp.diag=> toggle error-lens",
      },
      {
        key_scope.diagnostic.error_lens,
        function()
          require("telescope").load_extension("error-lens")
        end,
        mode = "n",
        desc = "scope.ext=> error lens diagnostics",
      },
    },
  },
}
