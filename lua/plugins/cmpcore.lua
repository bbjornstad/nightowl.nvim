local cmp = "hrsh7th/nvim-cmp"

return {
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    -- this needs to be original plugin
    -- but we want to mix and match.
    cmp,
    dependencies = "VonHeikemen/lsp-zero.nvim",
    opts = function(_, opts)
      local has_words_before = function()
        local unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match("%s")
            == nil
      end

      local luasnip = require("luasnip")
      local ucmp = require("cmp")

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        -- Remap carriage return to be the selection behavior of nvim-cmp.
        ["<CR>"] = ucmp.mapping({
          i = function(fallback)
            if ucmp.visible() and ucmp.get_active_entry() then
              ucmp.confirm({
                behavior = ucmp.ConfirmBehavior.Replace,
                select = false,
              })
            else
              fallback()
            end
          end,
          c = ucmp.mapping.confirm({
            behavior = ucmp.ConfirmBehavior.Replace,
            select = true,
          }),
          s = ucmp.mapping.confirm({ select = true }),
        }),
        -- enables supertab-like control of the popup completion window.
        ["<Tab>"] = ucmp.mapping(function(fallback)
          if ucmp.visible() then
            ucmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            ucmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = ucmp.mapping(function(fallback)
          if ucmp.visible() then
            ucmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  { "hrsh7th/cmp-nvim-lsp", dependencies = { cmp } },
  { "hrsh7th/cmp-buffer", dependencies = { cmp } },
  { "hrsh7th/cmp-path", dependencies = { cmp } },
  { "hrsh7th/cmp-cmdline", dependencies = { cmp } },
  { "hrsh7th/cmp-nvim-lua", dependencies = { cmp }, ft = "lua" },
  { "hrsh7th/cmp-nvim-lsp-signature-help", dependencies = { cmp } },
  { "hrsh7th/cmp-nvim-lsp-document-symbol", dependencies = { cmp } },
  { "petertriho/cmp-git", dependencies = { cmp } },
  { "lukas-reineke/cmp-rg", dependencies = { cmp } },
  { "tamago324/cmp-zsh", dependencies = { cmp }, ft = "zsh" },
  { "delphinus/cmp-ctags", dependencies = { cmp } },
  { "rcarriga/cmp-dap", dependencies = { cmp } },
  { "hrsh7th/cmp-calc", dependencies = { cmp } },
  { "ray-x/cmp-treesitter", dependencies = { cmp } },
  { "onsails/lspkind.nvim", dependencies = { cmp } },
  { "Saecki/crates.nvim", dependencies = { cmp }, ft = "rust" },
  { "tzachar/cmp-tabnine", dependencies = { cmp } },
  { "bydlw98/cmp-env", dependencies = { cmp } },
  { "nat-418/cmp-color-names.nvim", dependencies = { cmp } },
  { "jc-doyle/cmp-pandoc-references", dependencies = { cmp } },
  { "saadparwaiz1/cmp_luasnip", dependencies = { cmp } },
}
