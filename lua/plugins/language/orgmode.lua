-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local colors = require("kanagawa.colors").setup({ theme = "wave" }).palette
local inp = require("uutils.input")
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

local function norgbind(norgbind, op)
  op = op or {}
  local leader = norgbind.leader

  local binder = {}
  binder.__index = binder
  function binder.map(bound, action, opts)
    opts = opts or {}
    opts.leader = opts.leader or {}

    local sub = opts.leader.substitute_existing == nil and true
      or opts.leader.substitute_existing
    if sub then
      bound = bound:gsub(key_norg:leader() or "<localleader>", leader)
    end

    norgbind.map("norg", opts.mode or "n", bound, action, {
      buffer = true,
      desc = opts.desc or nil,
    })
  end
  function binder.remap_key(bound, seq_remap, opts)
    opts = opts or {}
    opts.leader = opts.leader or {}
    local sub = opts.leader.substitute_existing == nil and true
      or opts.leader.substitute_existing
    if sub then
      bound = bound:gsub(key_norg:leader() or "<localleader>", leader)
    end
    norgbind.remap_key("norg", opts.mode or "n", bound, seq_remap, {
      buffer = true,
      desc = opts.desc or nil,
    })
  end

  return setmetatable(binder, binder)
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
      { "nvim-treesitter/nvim-treesitter" },
      { "akinsho/org-bullets.nvim", ft = { "org" } },
      { "joaomsa/telescope-orgmode.nvim", ft = { "org" } },
      { "danilshvalov/org-modern.nvim", ft = { "org" } },
      { "lukas-reineke/headlines.nvim" },
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
          template = "* TODO %? | [%]\n  SCHEDULED: <%^{Start: |%<%Y-%m-%d %a>}> DEADLINE: <%^{End: |%<%Y-%m-%d %a>}>",
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
        keys = {
          {
            key_scope.neorg,
            function()
              require("telescope").extensions.neorg.neorg()
            end,
            mode = "n",
            desc = "scope.norg=> find",
          },
        },
      },
      "lukas-reineke/headlines.nvim",
      { "madskjeldgaard/neorg-figlet-module", optional = true, ft = "norg" },
      { "pysan3/neorg-templates", optional = true, ft = "norg" },
      { "tamton-aquib/neorg-jupyter", optional = true, ft = "norg" },
      { "laher/neorg-exec", optional = true, ft = "norg" },
    },
    build = ":Neorg sync-parsers",
    cmd = "Neorg",
    ft = { "norg" },
    opts = {
      load = {
        ["external.templates"] = {
          config = {
            templates_dir = vim.fs.joinpath(
              vim.fn.stdpath("config"),
              "templates/neorg-templates"
            ),
          },
        },
        -- ["external.jupyter"] = {},
        ["external.exec"] = {},
        -- ["external.integrations.figlet"] = {
        --   config = {
        --     font = "impossible",
        --     wrapInCodeTags = true,
        --   },
        -- },
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
              prosaic = "~/prsc",
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
        ["core.integrations.treesitter"] = {
          config = {},
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

        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            hook = function(binds)
              local binder = norgbind(binds, {})
              binds.remap_key(
                "norg",
                "n",
                "<C-Space>",
                "cc",
                { buffer = true, desc = "neorg=> cycle task status" }
              )
              binder.remap_key(
                key_norg.notes.new,
                "gnn",
                { desc = "neorg=> new note" }
              )
              binder.map(
                key_norg.linkable.find,
                "core.integrations.telescope.find_linkable",
                { desc = "neorg=> find linkables" }
              )
              binder.map(
                key_norg.linkable.insert,
                "core.integrations.telescope.insert_link",
                { desc = "neorg=> insert linkable" }
              )
              binder.map(
                key_norg.linkable.file,
                "core.integrations.telescope.insert_file_link",
                { desc = "neorg=> insert file linkable" }
              )
              binder.map(
                "<C-${ leader }><C-f>",
                "core.integrations.telescope.insert_file_link",
                {
                  leader = {
                    substitute_existing = false,
                  },
                  desc = "neorg=> insert file linkable",
                }
              )
              binder.map(
                "<C-${ leader }><C-l>)",
                "core.integrations.telescope.insert_link",
                {
                  leader = {
                    substitute_existing = false,
                  },
                  desc = "neorg=> insert linkable",
                }
              )
              binder.map(
                key_norg.metagen.inject,
                "core.esupports.metagen.inject_metadata",
                { desc = "neorg=> insert metadata" }
              )
              binder.map(
                key_norg.metagen.update,
                "core.esupports.metagen.update_metadata",
                { desc = "neorg=> update metadata" }
              )
              binder.map(key_norg.workspace.default, function()
                vim.cmd([[Neorg workspace default]])
              end, {
                desc = "neorg=> default workspace",
              })
              binder.map(key_norg.workspace.switch, function()
                inp.workspace([[Neorg workspace %s]])
              end, {
                desc = "neorg=> switch to workspace",
              })
              binder.map(key_norg.journal.daily, function()
                vim.cmd([[Neorg journal today]])
              end, {
                desc = "neorg=> daily journal (today)",
              })
              binder.map(key_norg.journal.yesterday, function()
                vim.cmd([[Neorg journal yesterday]])
              end, { desc = "neorg=> daily journal (yesterday)" })
              binder.map(key_norg.journal.tomorrow, function()
                vim.cmd([[Neorg journal tomorrow]])
              end, {

                desc = "neorg=> daily journal (tomorrow)",
              })
              binder.map(key_norg.journal.templates, function()
                vim.cmd([[Neorg journal template]])
              end, {
                desc = "neorg=> journal template",
              })
              binder.map(key_norg.journal.toc, function()
                vim.cmd([[Neorg journal toc]])
              end, {
                desc = "neorg=> journal contents",
              })
              binder.map(
                key_norg.search_headings,
                "core.integrations.telescope.search_headings",
                {
                  desc = "neorg=> search headings",
                }
              )
            end,
            neorg_leader = key_norg:leader(),
          },
          keys = {
            {
              key_norg.journal.daily,
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
  { "madskjeldgaard/neorg-figlet-module", enabled = false, ft = "norg" },
  { "pysan3/neorg-templates", ft = "norg" },
  { "tamton-aquib/neorg-jupyter", enabled = false, ft = "norg" },
  { "laher/neorg-exec", ft = "norg" },
}

return organization_tools
