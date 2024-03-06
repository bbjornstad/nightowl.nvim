---@module "cmp.mappings" main mappings for nvim-cmp, defining standard behavior
---for default popup completion menus and ideally a component to allow for the
---creation of cmp-submenus which hold a subset of sources or features.
---@author Bailey Bjornstad | ursa-major
---@license MIT

---@diagnostic disable: different-requires, undefined-field, missing-fields

local kenv_cmp = require("environment.keys").completion

local function fowl(module)
  return function(component, opts)
    local field = opts.field or {}
    local as_args = opts.varargs_as_args ~= nil and opts.varargs_as_args or true
    return function(...)
      local f = require(module)[component](field)
      return as_args
          and (vim.is_callable(f) and f(...) or vim.tbl_map(function(val)
            return f[val]
          end, { ... }))
        or f
    end
  end
end

local cmpfowl = fowl("cmp")

return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        keys = function()
          return {}
        end,
      },
      {
        "folke/which-key.nvim",
        opts = {
          triggers_nowait = {
            kenv_cmp.submenus:leader(),
          },
        },
      },
      { "VonHeikemen/lsp-zero.nvim" },
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      local has = require("funsak.lazy").has
      local cmp_action = require("lsp-zero").cmp_action()
      opts.mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Replace,
              })
            else
              fallback()
            end
          end,
          c = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end,
          s = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Replace,
              })
            else
              fallback()
            end
          end,
        }),
        ["<S-CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Insert,
              })
              fallback()
            end
          end,
          c = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end,
          s = function(fallback)
            if cmp.visible() and cmp.get_selected_entry() then
              cmp.confirm({
                select = false,
                behavior = cmp.ConfirmBehavior.Insert,
              })
            else
              fallback()
            end
          end,
        }),
        ["<C-S-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
        -- ["<TAB>"] = cmp_action.luasnip_supertab(),
        [kenv_cmp.jump.j] = cmp.mapping.select_next_item({
          select = cmp.SelectBehavior.Select,
          count = 1,
        }),
        [kenv_cmp.jump.next] = cmp_action.luasnip_supertab(),
        [kenv_cmp.jump.down] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Select,
          count = 4,
        }),
        [kenv_cmp.jump.k] = cmp.mapping.select_prev_item({
          select = cmp.SelectBehavior.Select,
          count = 1,
        }),
        [kenv_cmp.jump.previous] = cmp_action.luasnip_shift_supertab(),
        [kenv_cmp.jump.up] = cmp.mapping.select_prev_item({
          select = cmp.SelectBehavior.Select,
          count = 4,
        }),
        [kenv_cmp.jump.reverse.next] = cmp_action.luasnip_shift_supertab(),
        [kenv_cmp.jump.reverse.previous] = cmp_action.luasnip_supertab(),
        [kenv_cmp.jump.reverse.j] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Select,
          count = 1,
        }),
        [kenv_cmp.jump.reverse.k] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Select,
          count = 1,
        }),
        [kenv_cmp.jump.reverse.up] = cmp.mapping.select_next_item({
          selet = cmp.SelectBehavior.Select,
          cont = 4,
        }),
        [kenv_cmp.jump.reverse.down] = cmp.mapping.select_prev_item({
          select = cmp.SelectBehavior.Select,
          cont = 4,
        }),

        [kenv_cmp.docs.backward] = cmp.mapping.scroll_docs(-4),
        [kenv_cmp.docs.forward] = cmp.mapping.scroll_docs(4),
        [kenv_cmp.external.complete_common_string] = cmp.mapping.complete_common_string(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-c>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = cmp.SelectBehavior.Insert,
        }),
        ["<A-j>"] = cmp_action.luasnip_jump_forward(),
        ["<A-k>"] = cmp_action.luasnip_jump_backward(),
        [kenv_cmp.trigger] = cmp.mapping.complete(),
        -- we are going to make a mapping that will allow us to access focused
        -- groups of the completion menu with certain keystrokes. In particular, we
        -- have that Ctrl+Space should be the way that we bring up a completion
        -- menu. If we remap this so that it includes a submenu, we can have
        -- individual keymappings to access, say for instance, the fonts completion
        -- options specifically (C+o+f).
        [kenv_cmp.submenus.ai.libre] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "codeium" },
                  { name = "cmp_tabnine" },
                  { name = "cmp_ai" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.git] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "git" },
                  { name = "conventionalcommits" },
                  { name = "commit" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.shell] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "zsh" },
                  { name = "fish" },
                }, {
                  { name = "buffer" },
                  { name = "rg" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.glyph] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "fonts", option = { space_filter = "-" } },
                  { name = "nerdfont" },
                  { name = "emoji" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.lsp] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "nvim_lsp" },
                  { name = "nvim_lsp_signature_help" },
                  { name = "nvim_lsp_document_symbol" },
                  { name = "luasnip" },
                  { name = "dap" },
                  { name = "diag-codes" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.location] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "git" },
                  { name = "path" },
                  { name = "cmdline" },
                  { name = "look" },
                }),
              },
            })
          then
            fallback()
          end
        end,
        [kenv_cmp.submenus.ai.langfull] = function(fallback)
          if
            not cmp.complete({
              config = {
                sources = cmp.config.sources({
                  { name = "copilot" },
                  { name = "codeium" },
                  { name = "cmp_tabnine" },
                  { name = "cmp_ai" },
                  { name = "nvim_lsp" },
                  { name = "nvim_lsp_signature_help" },
                  { name = "nvim_lsp_document_symbol" },
                }),
              },
            })
          then
            fallback()
          end
        end,
      }, opts.mapping or {})
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local wk = require("which-key")
      wk.register({
        [kenv_cmp.submenus:leader()] = {
          name = "::| cmp.submenu |::",
          ["<C-Space>"] = { "cmp:| submenus |=> all" },
          ["<C-l>"] = { "cmp:| submenus |=> LSP" },
          ["<C-.>"] = { "cmp:| submenus |=> local session" },
          ["<C-:>"] = { "cmp:| submenus |=> language (full)" },
          ["<C-a>"] = { "cmp:| submenus |=> AI (libre)" },
          ["<C-g>"] = { "cmp:| submenus |=> git" },
          ["<C-s>"] = { "cmp:| submenus |=> shell" },
          ["<C-y>"] = { "cmp:| submenus |=> glyph" },
        },
      }, {
        mode = { "i", "s" },
      })
    end,
  },
}
