local key_scope = require("environment.keys").stems.telescope
local mapn = require("environment.keys").map("n")
local mapnv = require("environment.keys").map({ "n", "v" })

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
  -- "repo",
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
  "dir", -- "lsp-toggle",
  "color_names",
  "neoclip",
  "undo",
  "git_diffs",
  "find_pickers",
  "ports",
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

return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>"] = { name = "+nvim core fxns" },
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
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
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
      -- {
      --   "cljoly/telescope-repo.nvim",
      --   dependencies = { "nvim-telescope/telescope.nvim" },
      --   config = function()
      --     require("telescope").load_extension("repo")
      --   end,
      -- },
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
        init = function()
          mapn(
            "<leader><leader>",
            require("telescope").extensions.find_pickers.find_pickers,
            { desc = "scope=> extensions and pickers" }
          )
        end,
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
    },
    opts = {
      defaults = {
        layout_stragegy = "bottom_pane",
      },
      pickers = pickspec,
      extensions = extspec,
    },
    init = function()
      ---
      -- @module telescope.core: core keymappings.
      -- telescope.core: Find Files
      mapn(
        key_scope .. "ff",
        require("telescope.builtin").find_files,
        { desc = "scope=> search local files" }
      )
      -- telescope.core: Old Files
      mapn(
        key_scope .. "fo",
        require("telescope.builtin").oldfiles,
        { desc = "scope=> search oldfiles" }
      )
      -- telescope.core: Global Tags
      mapn(
        key_scope .. "g",
        require("telescope.builtin").tags,
        { desc = "scope=> search tags" }
      )
      -- telescope.core: Vim Commands
      mapn(
        key_scope .. "c",
        require("telescope.builtin").commands,
        { desc = "scope=> scope through vim commands" }
      )
      -- telescope.cort:. Help Tags
      mapn(
        key_scope .. "ht",
        require("telescope.builtin").help_tags,
        { desc = "scope=> search help tags" }
      )
      -- telescope.core: Manual Pages
      mapn(
        key_scope .. "hm",
        require("telescope.builtin").man_pages,
        { desc = "scope=> search man pages" }
      )
      -- telescope.core: Search History
      mapn(
        key_scope .. "hs",
        require("telescope.builtin").search_history,
        { desc = "scope=> scope history" }
      )
      -- telescope.core: Command History
      mapn(
        key_scope .. "hc",
        require("telescope.builtin").command_history,
        { desc = "scope=> command history" }
      )
      -- telescope.core: telescope builtins
      mapn(
        key_scope .. "i",
        require("telescope.builtin").builtin,
        { desc = "scope=> search telescope" }
      )
      -- telescope.core: open buffers
      mapn(
        key_scope .. "b",
        require("telescope.builtin").buffers,
        { desc = "scope=> search open buffers" }
      )
      -- telescope.core: treesitter nodes
      mapn(
        key_scope .. "e",
        require("telescope.builtin").treesitter,
        { desc = "scope=> search treesitter nodes" }
      )
      -- telescope.core: current buffer tags
      mapn(
        key_scope .. "t",
        require("telescope.builtin").current_buffer_tags,
        { desc = "scope=> search current buffer's tags" }
      )
      -- telescope.core: vim marks
      mapn(
        key_scope .. "m",
        require("telescope.builtin").marks,
        { desc = "scope=> search marks" }
      )
      -- telescope.core: loclist
      mapn(
        key_scope .. "y",
        require("telescope.builtin").loclist,
        { desc = "scope=> search loclist" }
      )
      -- telescope.core: keymappings
      mapn(
        key_scope .. "k",
        require("telescope.builtin").keymaps,
        { desc = "scope=> search defined keymappings" }
      )
      -- telescope.core: builtin pickers
      mapn(
        key_scope .. "o",
        require("telescope.builtin").pickers,
        { desc = "scope=> search telescope" }
      )
      -- telescope.core: vim options
      mapn(
        key_scope .. "v",
        require("telescope.builtin").vim_options,
        { desc = "scope=> search vim options" }
      )
      -- telescope.core: luasnip snippets
      mapn(
        key_scope .. "s",
        require("telescope").extensions.luasnip.luasnip,
        { desc = "scope=> search defined snippets" }
      )
      -- telescope.core: notifications
      mapn(
        key_scope .. "n",
        require("telescope").extensions.notify.notify,
        { desc = "scope=> search notifications" }
      )
      ---
      -- @module telescope.aux
      -- remap the default command history menu with the telescope menu since it
      -- is more convenient to exit and otherwise functions similarly. Plus
      -- unifies the ui just a bit more.
      mapnv("q:", "<nop>")
    end,
  },
}
