local env = require("environment.ui")
local mopts = require("funsak.table").mopts
local kenv = require("environment.keys")
local key_scope = kenv.scope
local key_tool = kenv.tool
local key_shortcut = kenv.shortcut
local key_newts = kenv.newts

local target_pickers = {
  "find_files",
  "git_files",
  "grep_string",
  "live_grep",
  "buffers",
  "oldfiles",
  "commands",
  "tags",
  "command_history",
  "search_history",
  "help_tags",
  "man_pages",
  "marks",
  "quickfix",
  "quickfixhistory",
  "loclist",
  "jumplist",
  "vim_options",
  "registers",
  "autocommands",
  "spell_suggest",
  "keymaps",
  "filetypes",
  "highlights",
  "current_buffer_fuzzy_find",
  "current_buffer_tags",
  "resume",
  "pickers",
  "lsp_references",
  "lsp_incoming_calls",
  "lsp_outgoing_calls",
  "lsp_document_symbols",
  "lsp_workspace_symbols",
  "lsp_dynamic_workspace_symbols",
  "diagnostics",
  "lsp_implementations",
  "lsp_definitions",
  "lsp_type_definitions",
  "git_commits",
  "git_bcommits",
  "git_branches",
  "git_status",
  "git_stash",
  "treesitter",
  "planets",
  "builtin",
  "reloader",
  "symbols",
}
-- env.targets.pickers
local target_extensions = {
  "fzf",
  "dap",
  "luasnip",
  "notify",
  "env",
  "heading",
  "repo",
  "changes",
  "menu",
  "recent_files",
  "project",
  "adjacent",
  "file_browser",
  "zoxide",
  "lazy",
  "ui-select",
  "glyph",
  "noice",
  "command_palette",
  "http",
  "frecency",
  "media_files",
  "conventional_commits",
  "xray23", -- this is for sessions, not sure why it still has this name
  "dir",
  "lsp-toggle",
  "color_names",
  "neoclip",
  "undo",
  "git_diffs",
  "find_pickers",
  "ports",
  "toggleterm",
  "notifications",
  "manix",
  "tasks",
  "whaler",
}

local scopeutils = require("parliament.utils.scope")
local pickspec = scopeutils.setup_pickers(target_pickers, {
  layout_strategy = "bottom_pane",
  layout_config = { height = 0.85 },
}, "ivy")
local extspec = scopeutils.setup_extensions(target_extensions, {
  layout_strategy = "bottom_pane",
  layout_config = { height = 0.85 },
}, "ivy")

local funext = scopeutils.extendoscope
local funblt = scopeutils.builtinoscope

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        [key_scope:leader()] = { name = "::| telescope |::" },
      },
    },
  },
  {
    "BurntSushi/ripgrep",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    event = { "FileType TelescopePrompt" },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_stragegy = "flex",
        layout_config = {
          horizontal = {
            size = {
              width = "85%",
              height = "60%",
            },
          },
          vertical = {
            size = {
              width = "85%",
              height = "85%",
            },
          },
        },
        mappings = {
          i = {
            ["<C-w>"] = "which_key",
            [key_scope:close()] = "close",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = function(prompt_bufnr)
              require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
              require("telescope.actions").open_qflist(prompt_bufnr)
            end,
          },
          n = {
            ["q"] = "close",
            ["qq"] = "close",
            [key_scope:close()] = "close",
            ["gh"] = "which_key",
            ["<c-j>"] = "move_selection_next",
            ["<c-k>"] = "move_selection_previous",
            ["<C-q>"] = function(prompt_bufnr)
              require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
              require("telescope.actions").open_qflist(prompt_bufnr)
            end,
          },
        },
        winblend = 14,
        prompt_prefix = " ",
        selection_caret = " ",
        initial_mode = "insert",
        dynamic_preview_title = true,
        prompt_title = "scope::searching...",
        scroll_strategy = "cycle",
        border = true,
        borderchars = env.borders.telescope,
        path_display = { "smart" },
        wrap_results = true,
      },
      -- pickers = pickspec,
    },
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
    },
    keys = {
      {
        key_scope.files.find,
        funblt("find_files"),
        mode = "n",
        desc = "scope:| pick |=> find files",
      },
      {
        key_scope.pickers.builtin,
        funblt("builtin"),
        mode = "n",
        desc = "scope:| pick |=> builtin",
      },
      {
        key_scope.treesitter,
        funblt("treesitter"),
        mode = "n",
        desc = "scope:| pick |=> treesitter nodes",
      },
      {
        key_scope.pickers.extensions,
        funblt("pickers"),
        mode = "n",
        desc = "scope:| pick |=> pickers",
      },
      {
        key_shortcut.buffers.scope,
        function()
          require("telescope.builtin").buffers()
        end,
        mode = "n",
        desc = "scope:| pick |=> buffers",
      },
    },
  },
  {
    "https://git.sr.ht/~havi/telescope-toggleterm.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    event = "TermOpen",
    opts = function(_, opts)
      opts.telescope_mappings = mopts(opts.telescope_mappings or {}, {
        ["<C-c>"] = require("telescope-toggleterm").actions.exit_terminal,
      })
    end,
    config = function(_, opts)
      require("telescope-toggleterm").setup(opts)
      require("telescope").load_extension("toggleterm")
    end,
    keys = {
      {
        key_scope.toggleterm,
        function()
          require("telescope").extensions.toggleterm.toggleterm()
        end,
        mode = "n",
        desc = "scope:| ext |=> toggleterm",
      },
    },
  },
  {
    "cljoly/telescope-repo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("repo")
    end,
    keys = {
      {
        key_scope.repo,
        function()
          require("telescope").extensions.repo.list()
        end,
        mode = "n",
        desc = "scope:| ext:repo |=> list",
      },
    },
  },
  {
    "LinArcX/telescope-env.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("env")
    end,
    keys = {
      {
        key_scope.env,
        function()
          require("telescope").extensions.env.env()
        end,
        mode = "n",
        desc = "scope:| ext |=> environment vars",
      },
    },
  },
  {
    "LinArcX/telescope-changes.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("changes")
    end,
    keys = {
      {
        key_scope.changes,
        function()
          require("telescope").extensions.changes.changes()
        end,
        mode = "n",
        desc = "scope:| ext |=> changes",
      },
    },
  },
  {
    "tsakirist/telescope-lazy.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("lazy")
    end,
    keys = {
      {
        key_scope.lazy,
        function()
          require("telescope").extensions.lazy.lazy()
        end,
        mode = "n",
        desc = "scope:| ext |=> lazy",
      },
    },
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("dap")
    end,
    keys = {
      {
        key_scope.dap.commands,
        function()
          require("telescope").extensions.dap.commands()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> commands",
      },
      {
        key_scope.dap.configurations,
        function()
          require("telescope").extensions.dap.configurations()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> configurations",
      },
      {
        key_scope.dap.list_breakpoints,
        function()
          require("telescope").extensions.dap.list_breakpoints()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> list breakpoints",
      },
      {
        key_scope.dap.variables,
        function()
          require("telescope").extensions.dap.variables()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> variables",
      },
      {
        key_scope.dap.frames,
        function()
          require("telescope").extensions.dap.frames()
        end,
        mode = "n",
        desc = "scope:| ext:dap |=> frames",
      },
    },
  },
  {
    "nvim-telescope/telescope-symbols.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function() end,
    keys = {
      {
        key_scope.glymbol.symbols,
        function()
          require("telescope.builtin").symbols({})
        end,
        mode = "n",
        desc = "scope:| ext |=> symbols",
      },
    },
  },
  {
    "ghassan0/telescope-glyph.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("glyph")
    end,
    keys = {
      {
        key_scope.glymbol.glyph,
        function()
          require("telescope").extensions.glyph.glyph()
        end,
        mode = "n",
        desc = "scope:| ext |=> glyph",
      },
    },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("undo")
    end,
    keys = {
      {
        key_scope.undo,
        function()
          require("telescope").extensions.undo.undo()
        end,
        mode = "n",
        desc = "scope:| ext |=> undo",
      },
    },
  },
  {
    "nat-418/telescope-color-names.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("color_names")
    end,
    keys = {
      {
        key_scope.color_names,
        function()
          require("telescope").extensions.color_names.color_names()
        end,
        mode = "n",
        desc = "scope:| ext |=> color names",
      },
    },
  },
  {
    "barrett-ruth/telescope-http.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("http")
    end,
    keys = {
      {
        key_scope.http,
        function()
          require("telescope").extensions.http.list()
        end,
        mode = "n",
        desc = "scope:| ext |=> http status code",
      },
    },
  },
  {
    "nvim-lua/popup.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
  },
  {
    "IrisRainbow7/telescope-lsp-server-capabilities.nvim",
    config = function(_, opts)
      require("telescope").load_extension("lsp_server_capabilities")
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {},
    keys = {
      {
        key_scope.lsp_capabilities,
        function()
          require("telescope").extensions.lsp_server_capabilities.lsp_server_capabilities()
        end,
        mode = "n",
        desc = "scope:| lsp |=> capabilities",
      },
    },
  },
}
