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
        ["<C-CR>"] = cmp.mapping(function(fallback)
          cmp.abort()
          fallback()
        end, { "i", "c", "s" }),
        -- ["<TAB>"] = cmp_action.luasnip_supertab(),
        [kenv_cmp.jump.j] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({
              behavior = cmp.SelectBehavior.Select,
              count = 1,
            })
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        [kenv_cmp.jump.next] = cmp_action.luasnip_supertab(),
        [kenv_cmp.jump.down] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({
              behavior = cmp.SelectBehavior.Select,
              count = 4,
            })
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        -- ["<S-TAB>"] = cmp_action.luasnip_shift_supertab(),
        [kenv_cmp.jump.k] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({
              behavior = cmp.SelectBehavior.Select,
              count = 1,
            })
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        [kenv_cmp.jump.previous] = cmp_action.luasnip_shift_supertab(),
        [kenv_cmp.jump.up] = cmp.mapping(function(fallback)
          if cmp.visible() then
            return cmp.select_prev_item({
              behavior = cmp.SelectBehavior.Select,
              count = 4,
            })
          else
            return fallback()
          end
        end, { "i", "c", "s" }),
        [kenv_cmp.jump.reverse.next] = cmp_action.luasnip_shift_supertab(),
        [kenv_cmp.jump.reverse.previous] = cmp_action.luasnip_supertab(),
        [kenv_cmp.jump.reverse.j] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({
              behavior = cmp.SelectBehavior.Select,
              count = 1,
            })
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        [kenv_cmp.jump.reverse.k] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({
              behavior = cmp.SelectBehavior.Select,
              count = 1,
            })
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        [kenv_cmp.jump.reverse.up] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({
              behavior = cmp.SelectBehavior.Select,
              count = 4,
            })
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        [kenv_cmp.jump.reverse.down] = cmp.mapping(function(fallback)
          if cmp.visible() then
            return cmp.select_prev_item({
              behavior = cmp.SelectBehavior.Select,
              count = 4,
            })
          else
            return fallback()
          end
        end, { "i", "c", "s" }),

        [kenv_cmp.docs.backward] = cmp.mapping.scroll_docs(-4),
        [kenv_cmp.docs.forward] = cmp.mapping.scroll_docs(4),
        [kenv_cmp.external.complete_common_string] = cmp.mapping
            .complete_common_string(),
        [kenv_cmp:accept()] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = cmp.SelectBehavior.Insert,
              })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        ["<A-j>"] = cmp_action.luasnip_jump_forward(),
        ["<A-k>"] = cmp_action.luasnip_jump_backward(),
        [kenv_cmp:cancel()] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() then
              cmp.abort()
            else
              fallback()
            end
          end,
          s = cmp.mapping.abort(),
          c = cmp.mapping.abort(),
        }),

        -- we are going to make a mapping that will allow us to access focused
        -- groups of the completion menu with certain keystrokes. In particular, we
        -- have that Ctrl+Space should be the way that we bring up a completion
        -- menu. If we remap this so that it includes a submenu, we can have
        -- individual keymappings to access, say for instance, the fonts completion
        -- options specifically (C+o+f).
        [kenv_cmp.submenus.ai.libre] = cmp.mapping(function(fallback)
          if
              not cmp.complete({
                config = {
                  sources = cmp.config.sources({
                    { name = "codeium" },
                    { name = "cmp_tabnine" },
                  }),
                },
              })
          then
            fallback()
          end
        end, { "i", "s" }),
        [kenv_cmp.submenus.git] = cmp.mapping(function(fallback)
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
        end, { "i", "s" }),
        [kenv_cmp.submenus.shell] = cmp.mapping(function(fallback)
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
        end, { "i", "s" }),
        [kenv_cmp.submenus.glyph] = cmp.mapping(function(fallback)
          if
              not cmp.complete({
                config = {
                  sources = cmp.config.sources({
                    { name = "fonts",   option = { space_filter = "-" } },
                    { name = "nerdfont" },
                    { name = "emoji" },
                  }),
                },
              })
          then
            fallback()
          end
        end, { "i", "s" }),
        [kenv_cmp.submenus.lsp] = cmp.mapping(function(fallback)
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
        end, { "i", "s" }),
        [kenv_cmp.submenus.location] = cmp.mapping(function(fallback)
          if
              not cmp.complete({
                config = {
                  sources = cmp.config.sources({
                    { name = "git" },
                    { name = "path" },
                    { name = "cmdline" },
                    { name = "look" },
                  }, {
                    { name = "rg" },
                    { name = "env" },
                    { name = "buffer" },
                  }),
                },
              })
          then
            fallback()
          end
        end, { "i", "s" }),
        [kenv_cmp.submenus.ai.langfull] = cmp.mapping(function(fallback)
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
        end, { "i", "s" }),
      }, opts.mapping or {})
    end,
  },
}
