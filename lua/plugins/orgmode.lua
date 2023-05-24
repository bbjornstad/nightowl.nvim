-- vim: set ft=lua ts=2 sts=2 sw=2 et:
return {
  {
    "nvim-orgmode/orgmode",
    dependencies = { "akinsho/org-bullets.nvim", opts = {} },
    ft = { "org" },
    init = function()
      if vim.fn.has("ufo") then
        pcall(vim.cmd, [[UfoDetatch]])
      end
    end,
    config = function(_, opts)
      -- Load custom tree-sitter grammar for org filetype
      require("orgmode").setup_ts_grammar()

      -- Tree-sitter configuration
      require("nvim-treesitter.configs").setup({
        -- If TS highlights are not enabled at all, or disabled via `disable` prop,
        -- highlighting will fallback to default Vim syntax highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "org" }, -- Required for spellcheck,
          -- some LaTex highlights and code block highlights that do not have ts grammar
        },
        ensure_installed = { "org" }, -- Or run :TSUpdate org
      })
      require("orgmode").setup(opts)
    end,
    opts = {
      org_agenda_files = { "~/.todo/agenda/**/*" },
      org_default_notes_file = "~/.todo/daily/daily.org",
      org_priority_highest = "A",
      org_priority_lowest = "L",
      org_priority_default = "B",
      win_split_mode = "vertical",
      org_todo_keywords = {
        "TODO(t)",
        "URGENT",
        "SUPER",
        "AWAIT",
        "PROGRESSING",
        "CHECK",
        "|",
        "DONE",
        "REPEATED",
        "GOTITALL",
        "NIXED",
      },
      org_todo_keyword_faces = {
        TODO = ":background #D9DADF :foreground blue :slant italic",
        DONE = ":background #D9DADF :foreground green :underline on",
        URGENT = ":background #D9DADF :foreground red :slant italic :underline on :weight bold",
        SUPER = ":background DarkRed :foreground #e8a7a7 :slant italic :weight bold :underline on",
        -- :foreground #21032b :slant italic',
        AWAIT = ":background #D9DADF :foreground #4c3757 :slant italic",
        REPEATED = ":background #D9DADF :foreground green :underline on",
        PROGRESSING = ":background #D9DADF :foreground purple :slant italic",
        CHECK = ":background #D9DADF :foreground NavyBlue :slant italic",
        GOTITALL = ":background #D9DADF :foreground black :underline on",
        NIXED = ":background #D9DADF :foreground DarkGrey :underline on",
      },
      org_capture_templates = {
        t = "Task",
        ts = {
          description = "Standard",
          template = "* TODO %? | [%]\n  SCHEDULED: %t DEADLINE: %t",
        },
        tu = { description = "Undated", template = "* TODO %? | [%]" },
        td = {
          description = "Discrete",
          template = "* TODO %? | [/]\n  SCHEDULED: %t DEADLINE: %t",
        },
        tf = {
          description = "Full",
          template = "* TODO %? | [%]\n  SCHEDULED: <%^{Start: |%<%Y-%m-%d %a>}> DEADLINE: <%^{End: |%<%Y-%m-%d %a>}>",
        },
        e = "Event",
        eu = {
          description = "Until",
          template = "* TODO %? | [%]\n  %t--<%^{End: |%<%Y-%m-%d %a>}>",
        },
        es = {
          description = "Single",
          template = "* TODO %? | [%]\n  <%^{Date: |%<%Y-%m-%d %a>}>",
        },
        er = {
          description = "Range",
          template = "* TODO %? | [%]\n  <%^{Start: |%<%Y-%m-%d %a>}>--<%^{End: |%<%Y-%m-%d %a>}>",
        },
      },
    },
  },
  {
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-neorg/neorg-telescope",
        dependencies = "nvim-telescope/telescope.nvim",
      },
    },
    build = ":Neorg sync-parsers",
    ft = { "norg" },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = { workspaces = { my_workspace = "~/." } },
        },
        ["core.completion"] = { engine = "nvim-cmp" },
      },
    },
  },
}
