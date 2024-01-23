local env = require("environment.ui")
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
  lsp.linters({ norg = { "proselint", "vale" } }),
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
    cmd = "Neorg",
    ft = { "norg" },
    config = function(_, opts)
      require("neorg").setup(opts)
      vim.cmd([[Neorg sync-parsers]])
    end,
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            folds = true,
            icon_preset = "diamond",
            icons = {
              todo = require("environment.ui").icons.norg.todo,
            },
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = require("environment.paths").neorg_workspaces,
            index = "note-index.norg",
            default_workspace = "org",
          },
        },
        ["core.qol.todo_items"] = {
          config = {
            create_todo_items = true,
            create_todo_parents = true,
            order = {
              { "undone", " " },
              { "pending", "-" },
              { "done", "x" },
            },
            order_with_children = {
              { "undone", " " },
              { "pending", "-" },
              { "done", "x" },
            },
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
            export_dir = "<export-dir>/<language>=export ",
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
                { buffer = true, desc = "norg:| task |=> cycle status" }
              )
              binds.remap_key(
                "norg",
                "n",
                key_norg.notes.new,
                "gnn",
                { desc = "norg:| note |=> new" }
              )
              binds.remap_key(
                "norg",
                "n",
                "<localleader>id",
                key_norg.dt.insert,
                { desc = "norg:| dt |=> insert" }
              )
              binder.map(
                "<C-d><C-t>",
                "core.tempus.insert-date-insert-mode",
                { mode = "i", desc = "norg:| dt |=> insert" }
              )
              binder.map(
                key_norg.linkable.find,
                "core.integrations.telescope.find_linkable",
                { desc = "norg:| link |=> find" }
              )
              binder.map(
                key_norg.linkable.insert,
                "core.integrations.telescope.insert_link",
                { desc = "norg:| link |=> insert" }
              )
              binder.map(
                key_norg.linkable.file,
                "core.integrations.telescope.insert_file_link",
                { desc = "norg:| link |=> insert file" }
              )
              binder.map(
                "<C-${ leader }><C-f>",
                "core.integrations.telescope.insert_file_link",
                {
                  leader = {
                    substitute_existing = false,
                  },
                  desc = "norg:| link |=> insert file",
                }
              )
              binder.map(
                "<C-${ leader }><C-l>)",
                "core.integrations.telescope.insert_link",
                {
                  leader = {
                    substitute_existing = false,
                  },
                  desc = "norg:| link |=> insert",
                }
              )
              binder.map(
                key_norg.metagen.inject,
                "core.esupports.metagen.inject_metadata",
                { desc = "norg:| meta |=> insert" }
              )
              binder.map(
                key_norg.metagen.update,
                "core.esupports.metagen.update_metadata",
                { desc = "norg:| meta |=> update" }
              )
              binder.map(key_norg.workspace.default, function()
                vim.cmd([[Neorg workspace default]])
              end, {
                desc = "norg:| ws |=> default",
              })
              binder.map(key_norg.workspace.switch, function()
                inp.workspace([[Neorg workspace %s]])
              end, {
                desc = "norg:| ws |=> select",
              })
              binder.map(key_norg.journal.daily, function()
                vim.cmd([[Neorg journal today]])
              end, {
                desc = "norg:| jrnl |=> today",
              })
              binder.map(key_norg.journal.yesterday, function()
                vim.cmd([[Neorg journal yesterday]])
              end, { desc = "norg:| jrnl |=> yesterday" })
              binder.map(key_norg.journal.tomorrow, function()
                vim.cmd([[Neorg journal tomorrow]])
              end, {
                desc = "norg:| jrnl |=> tomorrow",
              })
              binder.map(key_norg.journal.templates, function()
                vim.cmd([[Neorg journal template]])
              end, {
                desc = "norg:| jrnl |=> templates",
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
                  desc = "norg:| search |=> headings",
                }
              )
              binder.map(key_norg.export.to_file.md, function()
                vim.cmd(
                  [[Neorg export to-file ]]
                    ---@diagnostic disable-next-line: param-type-mismatch
                    .. vim.fs.normalize(vim.fn.expand("%"))({
                      desc = "norg:| export |=> file to md",
                    })
                )
              end)
              binder.map(key_norg.export.to_file.txt, function()
                vim.cmd([[Neorg export to-file]])
              end)
            end,
            neorg_leader = key_norg:leader(),
          },
        },
        ["external.templates"] = {
          config = {
            snippets_overwrite = {
              date_format = [[%Y-%m-%d]],
            },
            templates_dir = vim.fs.joinpath(
              vim.fn.stdpath("config"),
              "templates",
              "neorg-templates"
            ),
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
        desc = "norg:| jrnl |=> daily",
      },
      {
        key_norg.journal.yesterday,
        function()
          vim.cmd([[Neorg journal yesterday]])
        end,
        mode = "n",
        desc = "norg:| jrnl |=> yesterday",
      },
      {
        key_norg.journal.tomorrow,
        function()
          vim.cmd([[Neorg journal tomorrow]])
        end,
        mode = "n",
        desc = "norg:| jrnl |=> tomorrow",
      },
      {
        key_norg.journal.templates,
        function()
          vim.cmd([[Neorg journal template]])
        end,
        mode = "n",
        desc = "norg:| jrnl |=> contents",
      },
      {
        key_norg.journal.toc,
        function()
          vim.cmd([[Neorg journal toc]])
        end,
        mode = "n",
        desc = "norg:| jrnl |=> contents",
      },
      {
        key_norg.notes.new,
        function()
          vim.cmd([[new ./newscratch.norg]])
        end,
        mode = "n",
        desc = "norg:| note |=> new",
      },
    },
  },
  { "madskjeldgaard/neorg-figlet-module", ft = "norg" },
  { "pysan3/neorg-templates", ft = "norg" },
  { "tamton-aquib/neorg-jupyter", ft = "norg" },
  { "laher/neorg-exec", ft = "norg" },
}
