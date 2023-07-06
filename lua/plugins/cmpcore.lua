local ncmp = "hrsh7th/nvim-cmp"
local env = require("environment.ui")
local mapd = require("environment.keys").map({ "n", "v", "o" })

return {
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    ncmp,
    dependencies = {
      "VonHeikemen/lsp-zero.nvim",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "petertriho/cmp-git",
      "lukas-reineke/cmp-rg",
      "tamago324/cmp-zsh",
      "delphinus/cmp-ctags",
      "rcarriga/cmp-dap",
      "hrsh7th/cmp-calc",
      "ray-x/cmp-treesitter",
      -- "Saecki/crates.nvim",
      "bydlw98/cmp-env",
      "nat-418/cmp-color-names.nvim",
      "jc-doyle/cmp-pandoc-references",
      "amarakon/nvim-cmp-fonts",
      "davidmh/cmp-nerdfonts",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
      -- configure the display parameters for teh window, in particular
      -- changing the border and border padding options.
      opts.window = vim.tbl_deep_extend("force", {
        completion = cmp.config.window.bordered({
          border = env.borders.main,
          side_padding = 2,
        }),
        documentation = cmp.config.window.bordered({
          border = env.borders.main,
          side_padding = 2,
        }),
      }, opts.window or {})
      -- configure nvim-cmp sources.
      -- TODO integrate a completion menu system that can filter these by first
      -- items on the initialization of the menu.
      opts.sources = vim.list_extend(opts.sources, {
        {
          name = "nvim_lsp",
          max_item_count = 20,
          -- keyword_pattern = ">lsp",
          entry_filter = function(entry, ctx)
            local kind =
              require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]

            if kind == "Text" then
              return false
            end
            return true
          end,
          priority = 2,
        },
        {
          name = "nvim_lsp_signature_help",
          max_item_count = 20,
          priority = 2,
          -- keyword_pattern = ">sig",
        },
        {
          name = "nvim_lsp_document_symbol",
          max_item_count = 20,
          priority = 2,
          -- keyword_pattern = ">lsd",
        },
        {
          name = "treesitter",
          max_item_count = 20,
          -- keyword_pattern = ">tree",
        },
        {
          name = "luasnip",
          max_item_count = 20,
          priority = 2,
          -- keyword_pattern = ">snip",
        },
        { name = "dap", max_item_count = 20 }, -- keyword_pattern = ">dap" },
        {
          name = "rg",
          max_item_count = 20,
          keyword_length = 5,
          -- keyword_pattern = ">rg",
        },
        {
          name = "git",
          max_item_count = 20,
          keyword_length = 3,
          -- keyword_pattern = ">git",
        },
        {
          name = "env",
          max_item_count = 5,
          keyword_length = 5,
          -- keyword_pattern = ">env",
        },
        {
          name = "buffer",
          -- keyword_pattern = ">buf",
          max_item_count = 5,
          keyword_length = 7,
        },
        {
          name = "path",
          max_item_count = 15,
          keyword_length = 5,
          keyword_pattern = ">~",
        },
        { name = "calc", max_item_count = 10 }, -- keyword_pattern = ">math" },
        {
          name = "cmdline",
          max_item_count = 15,
          keyword_length = 5,
          -- keyword_pattern = ">/",
        },
        { name = "ctags", max_item_count = 10 }, -- keyword_pattern = ">tag" },
        {
          name = "emoji",
          max_item_count = 20,
          keyword_length = 3,
          -- keyword_pattern = ">emoji",
        },
        {
          name = "nerdfonts",
          max_item_count = 20,
          keyword_length = 3,
          -- keyword_pattern = ">nerd",
        },
        {
          name = "color_names",
          max_item_count = 10,
          keyword_length = 3,
          -- keyword_pattern = ">col",
        },
        {
          name = "fonts",
          option = { space_filter = "-" },
          max_item_count = 20,
          keyword_length = 3,
          -- keyword_pattern = ">font",
        },
      })

      -- ────────────────────────────────────────────────────────────----------
      -- The following changes the appearance of the menu. Noted changes:
      -- - different row field order
      -- - vscode codicons
      -- - vscode-styled colors
      opts.formatting = vim.tbl_deep_extend("force", {
        fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, cmp.ItemField.Menu },
        format = require("lspkind").cmp_format({
          preset = "codicons",
          maxwidth = 80,
          ellipsis_char = "...",
        }),
      }, opts.formatting or {})

      local colorizer =
        require("kanagawa.colors").setup({ theme = "wave" }).palette
      -- gray
      vim.api.nvim_set_hl(
        0,
        "CmpItemAbbrDeprecated",
        { bg = "NONE", strikethrough = true, fg = colorizer.lotusGrey3 }
      )
      -- blue
      vim.api.nvim_set_hl(
        0,
        "CmpItemAbbrMatch",
        { bg = "NONE", fg = colorizer.lotusBlue4 }
      )
      vim.api.nvim_set_hl(
        0,
        "CmpItemAbbrMatchFuzzy",
        { link = "CmpIntemAbbrMatch" }
      )
      -- light blue
      vim.api.nvim_set_hl(
        0,
        "CmpItemKindVariable",
        { bg = "NONE", fg = colorizer.lotusTeal1 }
      )
      vim.api.nvim_set_hl(
        0,
        "CmpItemKindInterface",
        { link = "CmpItemKindVariable" }
      )
      vim.api.nvim_set_hl(
        0,
        "CmpItemKindText",
        { link = "CmpItemKindVariable" }
      )
      -- pink
      vim.api.nvim_set_hl(
        0,
        "CmpItemKindFunction",
        { bg = "NONE", fg = colorizer.lotusPink } -- colorizer.lotusPink }
      )
      vim.api.nvim_set_hl(
        0,
        "CmpItemKindMethod",
        { link = "CmpItemKindFunction" }
      )
      -- front
      vim.api.nvim_set_hl(
        0,
        "CmpItemKindKeyword",
        { bg = "NONE", fg = colorizer.lotusViolet2 }
      )
      vim.api.nvim_set_hl(
        0,
        "CmpItemKindProperty",
        { link = "CmpItemKindKeyword" }
      )
      vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })

      -- -────────────────────────────────────────────────────────────---------
      -- The following changes the behavior of the menu. Noteably, we are
      -- turning off autocompletion on insert, in other words we need to hit one
      -- of the configured keys to be able to use the completion menu.
      opts.completion = vim.tbl_deep_extend("force", {
        autocomplete = false,
        scrolloff = true,
        --completeopt = "menuone,menu,noselect,noinsert",
      }, opts.completion or {})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    -- we are going to make a mapping that will allow us to access focused
    -- groups of the completion menu with certain keystrokes. In particular, we
    -- have that Ctrl+Space should be the way that we bring up a completion
    -- menu. If we remap this so that it includes a submenu, we can have
    -- individual keymappings to access, say for instance, the fonts completion
    -- options specifically (C+S+f).
    init = function()
      local key_cmp = ";"
      local function kf(key)
        return string.format("%s%s", key_cmp, key)
      end
      local cmp = require("cmp")
      mapd(kf(";"), function()
        cmp.complete({
          config = {
            sources = {
              { name = "codeium" },
              { name = "tabnine" },
            },
          },
        })
      end)
      mapd(kf("f"), function()
        cmp.complete({
          config = {
            sources = {
              {
                name = "fonts",
                option = { space_filter = "-" },
              },
            },
          },
        })
      end, { desc = "cmp=> fonts completion menu" })
      mapd(kf("i"), function()
        cmp.complete({
          config = {
            sources = {
              { name = "nerdfonts" },
              { name = "emoji" },
            },
          },
        })
      end, { desc = "cmp=> icons completion menu" })
      mapd(kf("l"), function()
        cmp.complete({
          config = {
            sources = {
              { name = "nvim_lsp" },
              { name = "nvim_lsp_signature_help" },
              { name = "nvim_lsp_document_symbol" },
              { name = "treesitter" },
              { name = "luasnip" },
              { name = "dap" },
            },
          },
        })
      end, { desc = "cmp=> lsp completion menu" })
      mapd(kf("."), function()
        cmp.complete({
          config = {
            sources = {
              { name = "git" },
              { name = "path" },
              { name = "rg" },
              { name = "env" },
              { name = "buffer" },
              { name = "cmdline" },
            },
          },
        })
      end, { desc = "cmp=> local completion menu" })
      if vim.fn.has("copilot") and env.ai.enabled.copilot then
        mapd(kf(":"), function()
          cmp.complete({
            config = {
              sources = {
                { name = "copilot" },
                { name = "codeium" },
                { name = "tabnine" },
                { name = "cmp_ai" },
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "nvim_lsp_document_symbol" },
              },
            },
          })
        end, { desc = "cmp=> available ai completion menus" })
      end
    end,
  },
  { "hrsh7th/cmp-buffer", dependencies = { ncmp } },
  { "hrsh7th/cmp-path", dependencies = { ncmp } },
  { "hrsh7th/cmp-cmdline", dependencies = { ncmp } },
  { "hrsh7th/cmp-nvim-lua", dependencies = { ncmp }, ft = "lua" },
  { "hrsh7th/cmp-nvim-lsp-signature-help", dependencies = { ncmp } },
  { "hrsh7th/cmp-nvim-lsp-document-symbol", dependencies = { ncmp } },
  { "petertriho/cmp-git", dependencies = { ncmp } },
  { "lukas-reineke/cmp-rg", dependencies = { ncmp } },
  { "tamago324/cmp-zsh", dependencies = { ncmp }, ft = "zsh" },
  { "delphinus/cmp-ctags", dependencies = { ncmp } },
  { "rcarriga/cmp-dap", dependencies = { ncmp } },
  { "hrsh7th/cmp-calc", dependencies = { ncmp } },
  { "ray-x/cmp-treesitter", dependencies = { ncmp } },
  -- { "Saecki/crates.nvim", dependencies = { ncmp }, ft = "rust" },
  { "bydlw98/cmp-env", dependencies = { ncmp } },
  { "nat-418/cmp-color-names.nvim", dependencies = { ncmp } },
  { "jc-doyle/cmp-pandoc-references", dependencies = { ncmp } },
  { "saadparwaiz1/cmp_luasnip", dependencies = { ncmp } },
  { "hrsh7th/cmp-emoji", dependencies = { ncmp } },
}
