-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local colors = require("kanagawa.colors").setup({ theme = "wave" }).palette
local inp = require("parliament.utils.input")
local kenv = require("environment.keys")
local key_time = kenv.time
local key_org = key_time.org
local key_norg = key_time.neorg
local key_scope = kenv.scope

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
    "joaomsa/telescope-orgmode.nvim",
    config = function(_, opts)
      require("telescope").load_extension("orgmode")
    end,
    opts = {},
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "rmd", "org", "norg" },
    config = function(_, opts)
      require("headlines").setup(opts)
    end,
    opts = {},
  },
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
          opts.highlight = vim.tbl_deep_extend("force", {
            enable = true,
            additional_vim_regex_highlighting = { "org" },
          }, opts.highlight or {})
        end,
      },
      { "akinsho/org-bullets.nvim",       ft = { "org" } },
      { "joaomsa/telescope-orgmode.nvim", ft = { "org" } },
      { "danilshvalov/org-modern.nvim",   ft = { "org" } },
      { "lukas-reineke/headlines.nvim" },
    },
    ft = { "org" },
    config = function(_, opts)
      -- Load custom tree-sitter grammar for org filetype
      require("orgmode").setup_ts_grammar()
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
        [key_org.task:leader()] = "Task",
        [key_org.task.standard] = {
          description = "Standard",
          template = "* TODO %? | [%]\n  SCHEDULED: %t DEADLINE: %t",
        },
        [key_org.task.undated] = {
          description = "Undated",
          template = "* TODO %? | [%]",
        },
        [key_org.task.discrete] = {
          description = "Discrete",
          template = "* TODO %? | [/]\n  SCHEDULED: %t DEADLINE: %t",
        },
        [key_org.task.full] = {
          description = "Full",
          template =
          "* TODO %? | [%]\n  SCHEDULED: <%^{Start: |%<%Y-%m-%d %a>}> DEADLINE: <%^{End: |%<%Y-%m-%d %a>}>",
        },
        [key_org.event:leader()] = "Event",
        [key_org.event._until] = {
          description = "Until",
          template = "* TODO %? | [%]\n  %t--<%^{End: |%<%Y-%m-%d %a>}>",
        },
        [key_org.event.single] = {
          description = "Single",
          template = "* TODO %? | [%]\n  <%^{Date: |%<%Y-%m-%d %a>}>",
        },
        [key_org.event.range] = {
          description = "Range",
          template =
          "* TODO %? | [%]\n  <%^{Start: |%<%Y-%m-%d %a>}>--<%^{End: |%<%Y-%m-%d %a>}>",
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
    "lukas-reineke/headlines.nvim",
    ft = { "org", "norg", "markdown", "md", "rmd", "quarto" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
  },
}

return organization_tools
