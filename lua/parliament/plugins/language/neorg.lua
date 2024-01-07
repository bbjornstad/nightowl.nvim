local kenv = require("environment.keys")
local key_norg = kenv.time.neorg
local key_scope = kenv.scope
local inp = require("parliament.utils.input")
local lsp = require("funsak.lsp")

local function norgbinder(norgbind, op)
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

return {
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
      { "madskjeldgaard/neorg-figlet-module", optional = true },
      { "pysan3/neorg-templates", optional = true },
      { "tamton-aquib/neorg-jupyter", optional = true },
      { "laher/neorg-exec", optional = true },
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
              prj = "~/prj",
              org = "~/org",
              journal = "~/org/journal",
              tasks = "~/org/tasks",
              prosaic = "~/org/prsc",
              nvim = "~/.config/nvim",
              nushell = "~/.config/nushell",
            },
            index = "note-index.norg",
            default_workspace = "org",
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.integrations.treesitter"] = {},
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
              local binder = norgbinder(binds, {})
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
                desc = "neorg.jrnl=> today",
              })
              binder.map(key_norg.journal.yesterday, function()
                vim.cmd([[Neorg journal yesterday]])
              end, { desc = "neorg.jrnl=> yesterday" })
              binder.map(key_norg.journal.tomorrow, function()
                vim.cmd([[Neorg journal tomorrow]])
              end, {
                desc = "neorg.jrnl=> tomorrow",
              })
              binder.map(key_norg.journal.templates, function()
                vim.cmd([[Neorg journal template]])
              end, {
                desc = "neorg.jrnl=> templates",
              })
              binder.map(key_norg.journal.toc, function()
                vim.cmd([[Neorg journal toc]])
              end, {
                desc = "neorg.jrnl=> journal contents",
              })
              binder.map(
                key_norg.search_headings,
                "core.integrations.telescope.search_headings",
                {
                  desc = "neorg.search=> headings",
                }
              )
            end,
            neorg_leader = key_norg:leader(),
          },
        },
      },
    },
    keys = {
      {
        key_norg.journal.daily,
        function()
          vim.cmd([[Neorg journal today]])
        end,
        mode = "n",
        desc = "neorg.jrnl=> daily",
      },
      {
        key_norg.journal.yesterday,
        function()
          vim.cmd([[Neorg journal yesterday]])
        end,
        mode = "n",
        desc = "neorg.jrnl=> yesterday",
      },
      {
        key_norg.journal.tomorrow,
        function()
          vim.cmd([[Neorg journal tomorrow]])
        end,
        mode = "n",
        desc = "neorg.jrnl=> tomorrow",
      },
      {
        key_norg.journal.templates,
        function()
          vim.cmd([[Neorg journal template]])
        end,
        mode = "n",
        desc = "neorg.jrnl=> contents",
      },
      {
        key_norg.journal.toc,
        function()
          vim.cmd([[Neorg journal toc]])
        end,
        mode = "n",
        desc = "neorg.jrnl=> contents",
      },
      {
        key_norg.notes.new,
        function()
          vim.cmd([[new ./newscratch.norg]])
        end,
        mode = "n",
        desc = "neorg.note=> new",
      },
    },
  },
  { "madskjeldgaard/neorg-figlet-module", ft = "norg" },
  { "pysan3/neorg-templates", ft = "norg" },
  { "tamton-aquib/neorg-jupyter", ft = "norg" },
  { "laher/neorg-exec", ft = "norg" },
  lsp.server("efm", {
    server = function(_)
      local function cfg(_)
        local langs = require("efmls-configs.defaults").languages()
        langs = vim.tbl_extend("force", langs, {
          norg = {
            require("efmls-configs.linters.vale"),
          },
        })
        return {
          filetypes = { "norg" },
          settings = {
            languages = langs,
          },
        }
      end
    end,
    dependencies = {
      "creativenull/efmls-configs-nvim",
    },
  }),
}
