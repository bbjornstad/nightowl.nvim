-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local colors = require("kanagawa.colors").setup({ theme = "wave" }).palette
local inp = require("uutils.input")
local key_time = require('environment.keys').time:leader()
local key_journal = require("environment.keys").time.neorg .. "j"

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
      "nvim-treesitter/nvim-treesitter",
      "akinsho/org-bullets.nvim",
      {
        "joaomsa/telescope-orgmode.nvim",
        config = function()
          require("telescope").load_extension("orgmode")
        end,
      },
      "danilshvalov/org-modern.nvim",
      "lukas-reineke/headlines.nvim",
    },
    ft = { "org" },
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
          template =
          "* TODO %? | [%]\n  SCHEDULED: <%^{Start: |%<%Y-%m-%d %a>}> DEADLINE: <%^{End: |%<%Y-%m-%d %a>}>",
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
    "nvim-neorg/neorg",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-neorg/neorg-telescope",
        dependencies = "nvim-telescope/telescope.nvim",
        ft = "norg",
        config = function(_, opts)
          require("telescope").load_extension("neorg")
        end,
      },
      "lukas-reineke/headlines.nvim",
      { "madskjeldgaard/neorg-figlet-module", ft = "norg" },
      { "pysan3/neorg-templates",             ft = "norg" },
      { "tamton-aquib/neorg-jupyter",         ft = "norg" },
      { "laher/neorg-exec",                   ft = "norg" },
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
          config = {
            workspaces = {
              journal = "~/.notes/journal",
              tasks = "~/.notes/tasks",
              prj = "~/prj",
              life = "~/.notes",
            },
            index = "note-index.norg",
            default_workspace = "life",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.integrations.telescope"] = {},
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
        ["core.export"] = {
          config = {
            export_dir = "<export-dir>/<language>",
          },
        },
        ["core.export.markdown"] = {
          config = {
            extension = "md",
            extensions = "all",
          },
        },
        ["core.ui"] = {},
        ["core.ui.calendar"] = {},
        ["core.esupports.metagen"] = {
          config = {
            type = "auto",
            update_date = true,
          },
        },
        ["external.templates"] = {
          config = {
            templates_dir = vim.fn.stdpath("config")
                .. "/templates/neorg-templates",
          },
        },
        ["external.jupyter"] = {},
        ["external.exec"] = {},
        ["external.integrations.figlet"] = {
          config = {
            font = "impossible",
            wrapInCodeTags = true,
          },
        },
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            hook = function(binds)
              local leader = binds.leader
              binds.remap_key(
                "norg",
                "n",
                "<C-Space>",
                "cc",
                { desc = "neorg=> cycle task status", buffer = true }
              )
              binds.remap_key(
                "norg",
                "n",
                leader .. "nn",
                "gnn",
                { buffer = true, desc = "neorg=> new note" }
              )
              binds.map(
                "norg",
                "n",
                leader .. "fl",
                "core.integrations.telescope.find_linkable",
                { buffer = true, desc = "neorg=> find linkables" }
              )
              binds.map(
                "norg",
                "n",
                leader .. "il",
                "core.integrations.telescope.insert_link",
                { buffer = true, desc = "neorg=> insert linkable" }
              )
              binds.map(
                "norg",
                "n",
                leader .. "if",
                "core.integrations.telescope.insert_file_link",
                { buffer = true, desc = "neorg=> insert file linkable" }
              )
              binds.map(
                "norg",
                "i",
                ("<C-%s><C-f>"):format(leader),
                "core.integrations.telescope.insert_file_link",
                { buffer = true, desc = "neorg=> insert file linkable" }
              )
              binds.map(
                "norg",
                "i",
                ("<C-%s><C-l>"):format(leader),
                "core.integrations.telescope.insert_link",
                { buffer = true, desc = "neorg=> insert linkable" }
              )
              binds.map(
                "norg",
                "n",
                leader .. "mi",
                "core.esupports.metagen.inject_metadata",
                { buffer = true, desc = "neorg=> insert metadata" }
              )
              binds.map(
                "norg",
                "n",
                leader .. "mu",
                "core.esupports.metagen.update_metadata",
                { buffer = true, desc = "neorg=> update metadata" }
              )
              binds.map("norg", "n", leader .. "wd", function()
                vim.cmd([[Neorg workspace default]])
              end, {
                buffer = true,
                desc = "neorg=> default workspace",
              })
              binds.map("norg", "n", leader .. "ws", function()
                inp.workspace([[Neorg workspace %s]])
              end, {
                buffer = true,
                desc = "neorg=> switch to workspace",
              })
              binds.map("norg", "n", leader .. "jd", function()
                vim.cmd([[Neorg journal today]])
              end, {
                buffer = true,
                desc = "neorg=> daily journal (today)",
              })
              binds.map(
                "norg",
                "n",
                leader .. "jy",
                function()
                  vim.cmd([[Neorg journal yesterday]])
                end,
                { buffer = true, desc = "neorg=> daily journal (yesterday)" }
              )
              binds.map("norg", "n", leader .. "jo", function()
                vim.cmd([[Neorg journal tomorrow]])
              end, {
                buffer = true,
                desc = "neorg=> daily journal (tomorrow)",
              })
              binds.map("norg", "n", leader .. "jt", function()
                vim.cmd([[Neorg journal template]])
              end, {
                buffer = true,
                desc = "neorg=> journal template",
              })
              binds.map("norg", "n", leader .. "jc", function()
                vim.cmd([[Neorg journal toc]])
              end, {
                buffer = true,
                desc = "neorg=> journal contents",
              })
              binds.map(
                "norg",
                "n",
                leader .. "sh",
                "core.integrations.telescope.search_headings",
                {
                  buffer = true,
                  desc = "neorg=> search headings",
                }
              )
            end,
            neorg_leader = key_time,
          },
          keys = {
            {
              key_journal .. "d",
              function()
                vim.cmd([[Neorg journal daily]])
              end,
              mode = "n",
              desc = "neorg=> daily journal (today)",
            },
          },
        },
      },
    },
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
