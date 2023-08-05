local key_scope = require("environment.keys").stems.telescope

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
}

local scopeutils = require("uutils.scope")
local pickspec = scopeutils.setup_pickers(target_pickers, {
  layout_strategy = "bottom_pane",
  layout_config = { height = 0.85 },
}, "ivy")
local extspec = scopeutils.setup_extensions(target_extensions, {
  layout_strategy = "bottom_pane",
  layout_config = { height = 0.85 },
  fzf = {
    fuzzy = true,
    override_generic_sorter = true,
    override_file_sorter = true,
    case_mode = "smart_case",
  },
  ["ui-select"] = {
    require("telescope.themes").get_dropdown({}),
  },
}, "ivy")

local function funext(extension_name, module_override)
  module_override = module_override or extension_name
  local scope = require("telescope")
  return function()
    scope.extensions[module_override][extension_name]()
  end
end

local function funblt(builtin_name, builtin_override)
  builtin_override = builtin_override or "telescope.builtin"
  return function()
    require(builtin_override)[builtin_name]()
  end
end

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        [key_scope] = { name = "+telescope" },
        -- TODO Add a few more of these baseline name mappings
        -- directly onto the which-key configuration here.
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "BurntSushi/ripgrep",
      {
        "https://git.sr.ht/~havi/telescope-toggleterm.nvim",
        dependencies = {
          "akinsho/toggleterm.nvim",
          "nvim-telescope/telescope.nvim",
          "nvim-lua/popup.nvim",
          "nvim-lua/plenary.nvim",
        },
        event = "TermOpen",
        config = function()
          require("telescope").load_extension("toggleterm")
        end,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release; cmake --build build --config Release; cmake --install build --prefix build",
        dependencies = { "junegunn/fzf", "junegunn/fzf.vim" },
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("ui-select")
        end,
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("file_browser")
        end,
      },
      {
        "cljoly/telescope-repo.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("repo")
        end,
      },
      {
        "LinArcX/telescope-env.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("env")
        end,
      },
      {
        "LinArcX/telescope-changes.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("changes")
        end,
      },
      {
        "LinArcX/telescope-command-palette.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("command_palette")
        end,
      },
      {
        "tsakirist/telescope-lazy.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("lazy")
        end,
      },
      {
        "octarect/telescope-menu.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("menu")
        end,
      },
      {
        "smartpde/telescope-recent-files",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("recent_files")
        end,
      },
      {
        "MaximilianLloyd/adjacent.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("adjacent")
        end,
      },
      {
        "benfowler/telescope-luasnip.nvim",
        module = "telescope._extensions.luasnip",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("luasnip")
        end,
      },
      {
        "crispgm/telescope-heading.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("heading")
        end,
      },
      {
        "nvim-telescope/telescope-project.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("project")
        end,
      },
      {
        "jvgrootveld/telescope-zoxide",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("zoxide")
        end,
      },
      {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("dap")
        end,
      },
      {
        "nvim-telescope/telescope-symbols.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function() end,
      },
      {
        "ghassan0/telescope-glyph.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("glyph")
        end,
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = {
          "kkharji/sqlite.lua",
          "nvim-tree/nvim-web-devicons",
          "nvim-telescope/telescope.nvim",
        },
        config = function()
          require("telescope").load_extension("frecency")
        end,
      },
      {
        "nvim-telescope/telescope-media-files.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("media_files")
        end,
      },
      {
        "olacin/telescope-cc.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("conventional_commits")
        end,
      },
      {
        "HUAHUAI23/telescope-session.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("xray23")
        end,
      },
      {
        "paopaol/telescope-git-diffs.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("git_diffs")
        end,
      },
      {
        "debugloop/telescope-undo.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("undo")
        end,
      },
      {
        "princejoogie/dir-telescope.nvim",
        opts = {
          hidden = true,
          no_ignore = false,
          show_preview = true,
        },
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = true,
      },
      {
        "nat-418/telescope-color-names.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("color_names")
        end,
      },
      {
        "keyvchan/telescope-find-pickers.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("find_pickers")
        end,
        keys = {
          {
            key_scope .. "<leader>",
            funext("find_pickers"),
            mode = "n",
            desc = "scope=> extensions and pickers",
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
      },
      {
        "AckslD/nvim-neoclip.lua",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("neoclip")
        end,
      },
      {
        "barrett-ruth/telescope-http.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("http")
        end,
      },
      {
        "LinArcX/telescope-ports.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("ports")
        end,
      },
      {
        "prochri/telescope-all-recent.nvim",
        dependencies = {
          "nvim-telescope/telescope.nvim",
          config = function()
            require("telescope-all-recent").setup({
              default = {
                sorting = "frecency",
              },
            })
          end,
        },
      },
      -- {
      --   "mrcjkb/telescope-manix",
      --   dependencies = {
      --     "nvim-lua/plenary.nvim",
      --     "nvim-telescope/telescope.nvim",
      --   },
      --   config = function()
      --     require("telescope").load_extension("manix")
      --   end,
      -- },
    },
    opts = {
      defaults = {
        layout_stragegy = "bottom_pane",
      },
      pickers = pickspec,
      extensions = extspec,
    },
    keys = {
      ---
      -- @module telescope.core: core keymappings.
      -- telescope.core: Find Files
      {
        key_scope .. "ff",
        funblt("find_files"),
        mode = "n",
        desc = "scope=> search local files",
      },
      -- telescope.core: Old Files
      {
        key_scope .. "fo",
        funblt("oldfiles"),
        mode = "n",
        desc = "scope=> search oldfiles",
      },
      -- telescope.core: Global Tags
      {
        key_scope .. "g",
        funblt("tags"),
        mode = "n",
        desc = "scope=> search tags",
      },
      -- telescope.core: Vim Commands
      {
        key_scope .. "c",
        funblt("commands"),
        mode = "n",
        desc = "scope=> scope through vim commands",
      },
      -- telescope.cort:. Help Tags
      {
        key_scope .. "ht",
        funblt("help_tags"),
        mode = "n",
        desc = "scope=> search help tags",
      },
      -- telescope.core: Manual Pages
      {
        key_scope .. "hm",
        funblt("man_pages"),
        mode = "n",
        desc = "scope=> search man pages",
      },
      -- telescope.core: Search History
      {
        key_scope .. "hs",
        funblt("search_history"),
        mode = "n",
        desc = "scope=> scope history",
      },
      -- telescope.core: Command History
      {
        key_scope .. "hc",
        funblt("command_history"),
        mode = "n",
        desc = "scope=> command history",
      },
      -- telescope.core: telescope builtins
      {
        key_scope .. "i",
        funblt("builtin"),
        mode = "n",
        desc = "scope=> search telescope",
      },
      -- telescope.core: open buffers
      {
        key_scope .. "b",
        funblt("buffers"),
        mode = "n",
        desc = "scope=> search open buffers",
      },
      -- telescope.core: treesitter nodes
      {
        key_scope .. "e",
        funblt("treesitter"),
        mode = "n",
        desc = "scope=> search treesitter nodes",
      },
      -- telescope.core: current buffer tags
      {
        key_scope .. "t",
        funblt("current_buffer_tags"),
        mode = "n",
        desc = "scope=> search current buffer's tags",
      },
      -- telescope.core: vim marks
      {
        key_scope .. "m",
        funblt("marks"),
        mode = "n",
        desc = "scope=> search marks",
      },
      -- telescope.core: loclist
      {
        key_scope .. "y",
        funblt("loclist"),
        mode = "n",
        desc = "scope=> search loclist",
      },
      -- telescope.core: keymappings
      {
        key_scope .. "k",
        funblt("keymaps"),
        mode = "n",
        desc = "scope=> search defined keymappings",
      },
      -- telescope.core: builtin pickers
      {
        key_scope .. "o",
        funblt("pickers"),
        mode = "n",
        desc = "scope=> search telescope",
      },
      -- telescope.core: vim options
      {
        key_scope .. "v",
        funblt("vim_options"),
        mode = "n",
        desc = "scope=> search vim options",
      },
      -- telescope.core: luasnip snippets
      {
        key_scope .. "s",
        funext("luasnip"),
        mode = "n",
        desc = "scope=> search defined snippets",
      },
      -- telescope.core: notifications
      {
        key_scope .. "n",
        funext("notify"),
        mode = "n",
        desc = "scope=> search notifications",
      },
      ---
      -- @module telescope.aux
      -- remap the default command history menu with the telescope menu since it
      -- is more convenient to exit and otherwise functions similarly. Plus
      -- unifies the ui just a bit more.
      {
        "q:",
        funblt("command_history"),
        mode = { "n", "v" },
        desc = "scope=> command history",
      },
    },
  },
}
