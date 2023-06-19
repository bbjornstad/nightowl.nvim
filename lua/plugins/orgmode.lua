-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local colors = require("kanagawa.colors").setup({ theme = "wave" }).palette

local function colorize(bg, fg, opts)
  opts = opts or {}

  local retstr = string.format(":background %s :foreground %s", bg, fg)
  for name, val in pairs(opts) do
    retstr = string.format("%s :%s %s", retstr, name, val)
  end
  return retstr
end

local organization_tools = {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      { "akinsho/org-bullets.nvim", opts = {} },
      {
        "joaomsa/telescope-orgmode.nvim",
        config = function()
          require("telescope").load_extension("orgmode")
        end,
      },
    },
    ft = { "org" },
    init = function()
      if vim.fn.has("ufo") then
        require("ufo").detach()
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
      org_priority_default = "E",
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
        TODO = colorize(colors.sumiInk4, colors.crystalBlue, {
          weight = "bold",
        }),
        DONE = colorize(colors.sumiInk4, colors.lotusGreen2, {
          underline = "on",
        }),
        URGENT = colorize(colors.sumiInk4, colors.dragonRed, {
          underline = "on",
          weight = "bold",
        }),
        SUPER = colorize(colors.sumiInk4, colors.autumnRed, {
          slant = "italic",
          underline = "on",
        }),
        AWAIT = colorize(colors.sumiInk4, colors.dragonPink, {
          slant = "italic",
        }),
        REPEATED = colorize(
          colors.sumiInk4,
          colors.lotusGreen3,
          { underline = "on" }
        ),
        PROGRESSING = colorize(
          colors.sumiInk4,
          colors.dragonPink,
          { slant = "italic" }
        ),
        CHECK = colorize(
          colors.sumiInk4,
          colors.lotusBlue4,
          { slant = "italic" }
        ),
        GOTITALL = colorize(
          colors.sumiInk4,
          colors.sumiInk0,
          { underline = "on" }
        ),
        NIXED = colorize(
          colors.sumiInk4,
          colors.fujiGray,
          { underline = "on" }
        ),
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
      mappings = {
        org = {
          org_toggle_checkbox = "cc",
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
    init = function()
      if vim.fn.has("ufo") then
        require("ufo").detach()
      end
    end,
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = { workspaces = { my_workspace = "~/." } },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
      },
    },
  },
}

if vim.fn.has("orgmode") or vim.fn.has("neorg") then
  table.insert(organization_tools, {
    {
      "lukas-reineke/headlines.nvim",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {},
    },
  })
end

return organization_tools
