-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local ncmp = "hrsh7th/nvim-cmp"
local env = require("environment.ui")
local mapd = require("environment.keys").map({ "n", "v", "i", "o" })

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
      -- we don't want to include the next part because it is already included
      -- in the call to friendly-snippets configuration via LazyVim
      -- require("luasnip.loaders.from_vscode").lazy_load()
      -- This one is ok because it is not loaded afaict by way of LazyVim
      require("luasnip.loaders.from_snipmate").lazy_load()
      -- this is ok, we now put our sources and configuration for such sources
      -- in this list item below
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
      opts.sources = vim.list_extend(opts.sources, {
        { name = "nvim-lsp", max_item_count = 10 },
        { name = "nvim_lsp_signature_help", max_item_count = 8 },
        { name = "treesitter", max_item_count = 8 },
        { name = "luasnip", max_item_count = 8 },
        { name = "dap", max_item_count = 8 },
        { name = "rg", max_item_count = 8 },
        { name = "env", max_item_count = 5 },
        { name = "buffer", max_item_count = 5 },
        { name = "path", max_item_count = 5 },
        { name = "calc", max_item_count = 3 },
        { name = "cmdline", max_item_count = 5 },
        -- { name = "ctags", max_item_count = 5 },
        {
          name = "fonts",
          option = { space_filter = "-" },
          max_item_count = 8,
        },
        { name = "emoji", max_item_count = 10 },
        -- { name = "nerdfonts", max_item_count = 8 },
        { name = "color_names", max_item_count = 5 },
      })
      opts.formatting = vim.tbl_deep_extend("force", {
        fields = { "kind", "abbr", "menu" },
        format = require("lspkind").cmp_format({
          mode = "symbol",
          preset = "codicons",
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      }, opts.formatting or {})
      opts.completion = vim.tbl_deep_extend("force", {
        autocomplete = false,
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
      mapd(kf("f"), function()
        cmp.complete({
          config = {
            sources = {
              { name = "fonts", option = { space_filter = "-" } },
            },
          },
        })
      end, { desc = "cmp:>> fonts completion menu" })
      mapd(kf(";"), function()
        if vim.fn.has("copilot") then
          cmp.complete({
            config = {
              sources = {
                { name = "copilot", option = {} },
              },
            },
          })
        end
      end)
    end,
  },
  { "hrsh7th/cmp-nvim-lsp", dependencies = { ncmp } },
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
