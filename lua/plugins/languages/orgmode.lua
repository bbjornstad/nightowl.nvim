-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local colors = require("kanagawa.colors").setup({ theme = "wave" }).palette

local function ucall(mod, ref, opts)
  opts = opts or nil
  local function uwrap()
    local ok, modres = pcall(require, mod)
    if ok then
      local innerok, innerres = pcall(modres, ref, opts)
      return innerres
    end
  end
  return uwrap
end

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
      { "nvim-treesitter/nvim-treesitter" },
      { "akinsho/org-bullets.nvim", opts = {} },
      {
        "joaomsa/telescope-orgmode.nvim",
        config = function()
          require("telescope").load_extension("orgmode")
        end,
      },
    },
    ft = { "org" },
    -- init = ucall("ufo", "detach", {}),
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
      org_agenda_files = { "~/.agenda/**/*" },
      org_default_notes_file = "~/.notes/agenda/daily.org",
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
    "danilshvalov/org-modern.nvim",
    dependencies = { "nvim-orgmode/orgmode" },
    ft = { "org" },
    opts = {},
    config = function()
      local env = require("environment.ui").borders
      local Menu = require("org-modern.menu")
      require("orgmode").setup({
        ui = {
          menu = {
            handler = function(data)
              Menu:new({
                window = {
                  margin = { 1, 0, 1, 0 },
                  padding = { 1, 2, 1, 2 },
                  title_pos = "center",
                  border = env.main,
                  zindex = 30,
                },
                icons = {
                  separator = "➜",
                },
              }):open(data)
            end,
          },
        },
      })
    end,
  },
  {
    "nvim-neorg/neorg",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-neorg/neorg-telescope",
        dependencies = "nvim-telescope/telescope.nvim",
      },
    },
    build = ":Neorg sync-parsers",
    cmd = "Neorg",
    ft = { "norg" },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            folds = true,
            icon_preset = "diamond",
          },
        },
        ["core.dirman"] = {
          config = { workspaces = { journal = "~/.notes/journal" } },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.summary"] = {
          config = {
            strategy = "default",
          },
        },
        ["core.journal"] = {
          config = {
            journal_folder = ".",
            strategy = "flat",
            use_template = true,
            workspace = "journal",
          },
        },
        -- ["core.ui.calendar"] = {},
      },
    },
  },
  {
    {
      "lukas-reineke/headlines.nvim",
      ft = { "org", "norg", "markdown", "md", "rmd", "quarto" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {},
    },
  },
}

return organization_tools
