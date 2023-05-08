-- local env = require("environment.scope")
-- print(string.format("Telescope environment found:\n{}", vim.inspect(env)))

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
  "dap", -- "luasnip",
  "notify",
  "env",
  "heading",
  "repo",
  "changes",
  "menu",
  "recent_files",
  "software-licenses",
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
  "dir", -- "lsp-toggle",
  "color_names",
  "neoclip",
  "undo",
  "git_diffs",
  "find_pickers",
  "ports",
}
-- print("Pickers: " .. vim.inspect(target_pickers))
-- print("Extensions: " .. vim.inspect(target_extensions))

local scopeutils = require("uutils.scope")
local pickspec = scopeutils.setup_pickers(target_pickers, {
  layout_strategy = "bottom_pane",
  layout_config = { height = 0.7 },
}, "ivy")
local extspec = scopeutils.setup_extensions(target_extensions, {
  layout_strategy = "bottom_pane",
  layout_config = { height = 0.7 },
  fzf = {
    fuzzy = true,
    override_generic_sorter = true,
    override_file_sorter = true,
    case_mode = "smart_case",
  },
}, "ivy")

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        dependencies = { "junegunn/fzf", "junegunn/fzf.vim" },
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "BurntSushi/ripgrep",
      "cljoly/telescope-repo.nvim",
      "chip/telescope-software-licenses.nvim",
      "LinArcX/telescope-env.nvim",
      "LinArcX/telescope-changes.nvim",
      "LinArcX/telescope-command-palette.nvim",
      "tsakirist/telescope-lazy.nvim",
      "octarect/telescope-menu.nvim",
      "smartpde/telescope-recent-files",
      "MaximilianLloyd/adjacent.nvim",
      {
        "benfowler/telescope-luasnip.nvim",
        module = "telescope._extensions.luasnip",
        config = function()
          require("telescope").load_extension("luasnip")
        end,
      },
      "crispgm/telescope-heading.nvim",
      "nvim-telescope/telescope-project.nvim",
      "jvgrootveld/telescope-zoxide",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "ghassan0/telescope-glyph.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = {
          "kkharji/sqlite.lua",
          "nvim-tree/nvim-web-devicons",
        },
      },
      "nvim-telescope/telescope-media-files.nvim",
      "olacin/telescope-cc.nvim",
      "HUAHUAI23/telescope-session.nvim",
      "paopaol/telescope-git-diffs.nvim",
      "debugloop/telescope-undo.nvim",
      "princejoogie/dir-telescope.nvim",
      "nat-418/telescope-color-names.nvim",
      "keyvchan/telescope-find-pickers.nvim",
      {
        "adoyle-h/lsp-toggle.nvim",
        dependencies = "neovim/nvim-lspconfig",
        config = function()
          require("lsp-toggle").setup({
            create_cmds = true,
            telescope = true,
          })
        end,
      },
      "AckslD/nvim-neoclip.lua",
      "barrett-ruth/telescope-http.nvim",
      "LinArcX/telescope-ports.nvim",
    },
    opts = { defaults = {}, pickers = pickspec, extensions = extspec },
    keys = require("environment.keys").telescope,
  },
}
