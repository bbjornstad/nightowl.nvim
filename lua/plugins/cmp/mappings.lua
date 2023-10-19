---@module mappings main mappings for nvim-cmp, defining standard behavior for
---default popup completion menus and ideally a component to allow for the
---creation of cmp-submenus which hold a subset of sources or features.
---@author Bailey Bjornstad | ursa-major
---@license MIT
-- vim: set ft=lua et ts=2 sw=2 sts=2: --

---@diagnostic disable: missing-fields

local kenv_cmp = require("environment.keys").completion
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match("%s")
      == nil
end

return {
  {
    "hrsh7th/nvim-cmp",
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
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.mapping = cmp.mapping.preset.insert(vim.tbl_deep_extend("force", {
        [kenv_cmp.confirm] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = cmp.SelectBehavior.Select,
              })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({
            select = cmp.SelectBehavior.Insert,
          }),
          c = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = cmp.SelectBehavior.Insert,
          }),
        }),
        [kenv_cmp.jump.forward] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if cmp.visible() then
            cmp.select_next_item()
          -- note the use of the `expand_or_locally_jumpable` function:
          -- this restricts possible targets to only those in the local snippet
          -- region and no more external choices
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        [kenv_cmp.jump.backward] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")

          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        [kenv_cmp.docs.backward] = cmp.mapping.scroll_docs(-4),
        [kenv_cmp.docs.forward] = cmp.mapping.scroll_docs(4),
        [kenv_cmp.external.complete_common_string] = cmp.mapping.complete_common_string(),
        [kenv_cmp:accept()] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = cmp.SelectBehavior.Insert,
            })
          else
            fallback()
          end
        end, { "i", "c", "s" }),
        [kenv_cmp:cancel()] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() then
              cmp.abort()
            else
              fallback()
            end
          end,
        }),

        -- we are going to make a mapping that will allow us to access focused
        -- groups of the completion menu with certain keystrokes. In particular, we
        -- have that Ctrl+Space should be the way that we bring up a completion
        -- menu. If we remap this so that it includes a submenu, we can have
        -- individual keymappings to access, say for instance, the fonts completion
        -- options specifically (C+o+f).
        [kenv_cmp.submenus.ai.libre] = cmp.mapping(function(fallback)
          if
            not cmp.mapping.complete({
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
            not cmp.mapping.complete({
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
            not cmp.mapping.complete({
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
            not cmp.mapping.complete({
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
        end, { "i", "s" }),
        [kenv_cmp.submenus.lsp] = cmp.mapping(function(fallback)
          if
            not cmp.mapping.complete({
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
            not cmp.mapping.complete({
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
            not cmp.mapping.complete({
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
      }, opts.mapping or {}))
    end,
  },
}
