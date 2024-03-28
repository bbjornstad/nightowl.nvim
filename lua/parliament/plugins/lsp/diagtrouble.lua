-- SPDX-FileCopyrightText: 2024 Bailey Bjornstad | ursa-major <bailey@bjornstad.dev>
-- SPDX-License-Identifier: MIT

-- MIT License

--  Copyright (c) 2024 Bailey Bjornstad | ursa-major bailey@bjornstad.dev

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

---@module "parliament.plugins.lsp.diagtrouble"
---@author Bailey Bjornstad | ursa-major
---@license MIT

local env = require("environment.ui")
local kenv = require("environment.keys")
local key_trouble = kenv.diagnostic
local key_ui = kenv.ui

return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      position = "bottom",
      height = 16,
      width = 24,
      icons = true,
      mode = "workspace_diagnostics",
      fold_open = "",
      fold_closed = "",
      group = true,
      padding = true,
      cycle_results = true,
      action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = { "<cr>", "<tab>", "<2-leftmouse>" }, -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" }, -- open buffer in new split
        open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        open_tab = { "<c-t>" }, -- open buffer in new tab
        jump_close = { "o" }, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        switch_severity = "s", -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        open_code_href = "c", -- if present, open a URI with more information about the diagnostic error
        close_folds = { "zM", "zm" }, -- close all folds
        open_folds = { "zR", "zr" }, -- open all folds
        toggle_fold = { "zA", "za" }, -- toggle fold of current file
        previous = "k", -- previous item
        next = "j", -- next item
        help = "?", -- help menu
      },
      multiline = true, -- render multi-line messages
      indent_lines = true, -- add an indent guide below the fold icons
      win_config = { border = env.borders.main }, -- window configuration for floating windows. See |nvim_open_win()|.
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false, -- automatically fold a file trouble list at creation
      auto_jump = { "lsp_definitions", "lsp_implementations" }, -- for the given modes, automatically jump if there is only a single result
      include_declaration = {
        "lsp_references",
        "lsp_implementations",
        "lsp_definitions",
      }, -- for the given modes, include the declaration of the current symbol in the results
      signs = {
        -- icons / text used for a diagnostic
        error = env.icons.diagnostic.Error,
        warning = env.icons.diagnostic.Warn,
        hint = env.icons.diagnostic.Hint,
        information = env.icons.diagnostic.Info,
        other = env.icons.diagnostic.Info,
      },
      use_diagnostic_signs = false,
    },
    config = function(_, opts)
      require("trouble").setup(opts)
    end,
    keys = {
      {
        key_trouble.toggle,
        function()
          require("trouble").toggle()
        end,
        mode = "n",
        desc = "lsp:| trouble |=> toggle",
      },
      {
        key_trouble.workspace,
        function()
          require("trouble").toggle("workspace_diagnostics")
        end,
        mode = "n",
        desc = "lsp:| trouble |=> workspace",
      },
      {
        key_trouble.document,
        function()
          require("trouble").toggle("document_diagnostics")
        end,
        mode = "n",
        desc = "lsp:| trouble |=> document",
      },
      {
        key_trouble.quickfix,
        function()
          require("trouble").toggle("quickfix")
        end,
        mode = "n",
        desc = "lsp:| trouble |=> quickfix list",
      },
      {
        key_trouble.loclist,
        function()
          require("trouble").toggle("loclist")
        end,
        mode = "n",
        desc = "lsp:| trouble |=> location list",
      },
      {
        key_trouble.lsp_references,
        function()
          require("trouble").toggle("lsp_references")
        end,
        mode = "n",
        desc = "lsp:| trouble |=> lsp references",
      },
    },
    event = "LspAttach",
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          -- icon used for the sign, and in search results
          icon = "󰅝 ",
          -- can be a hex color, or a named color (see below)
          color = "error",
          -- a set of other keywords that all map to this FIX keywords
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = "󱔳 ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󱕎 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󱝾 ", color = "hint", alt = { "INFO" } },
        TEST = {
          icon = "⏲ ",
          color = "test",
          alt = { "TESTING", "PASSED", "FAILED" },
        },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "Identifier", "#7C3AED" },
        test = { "Identifier", "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end,
    event = {
      "VeryLazy",
    },
    keys = {
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        mode = "n",
        desc = "todo:| comments |=> previous",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        mode = "n",
        desc = "todo:| comments |=> next",
      },
    },
  },
  {
    "RaafatTurki/corn.nvim",
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
      blacklisted_modes = { "i" },
      border_style = env.borders.main,
      on_toggle = function(is_hidden) end,
      item_preprocess_func = function(item)
        return item
      end,
    },
    event = "LspAttach",
    keys = {
      {
        key_ui.diagnostics.corn.file,
        function()
          require("corn").scope("file")
        end,
        mode = "n",
        desc = "ui:diag| corn |=> scope to file",
      },
      {
        key_ui.diagnostics.corn.line,
        function()
          require("corn").scope("line")
        end,
        mode = "n",
        desc = "ui:diag| corn |=> scope to line",
      },
      {
        key_ui.diagnostics.corn.cycle,
        function()
          require("corn").scope_cycle()
        end,
        mode = "n",
        desc = "ui:diag| corn |=> cycle scope",
      },
      {
        key_ui.diagnostics.corn.toggle,
        function()
          require("corn").toggle()
        end,
        mode = "n",
        desc = "ui:diag| corn |=> toggle",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = "󰛯",
        },
        severity_sort = true,
        float = {
          border = env.borders.alt,
          title = "󰼀 lsp::diagnostic",
          title_pos = "right",
        },
      })
      opts.log_level = vim.log.levels.WARN
    end,
  },
}
