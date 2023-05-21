-- vim: set ft=lua ts=2 sts=2 sw=2 et:
local ncmp = "hrsh7th/nvim-cmp"
local env = require("environment.ui")

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
      "Saecki/crates.nvim",
      "bydlw98/cmp-env",
      "nat-418/cmp-color-names.nvim",
      "jc-doyle/cmp-pandoc-references",
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
      --opts.window = opts.window or {}
      --table.insert(opts.window, {
      --  completion = cmp.config.window.bordered(),
      --  documentation = cmp.config.window.bordered(),
      --})
      opts.view = opts.view or {}
      table.insert(opts.view, { entries = { separator = " | " } })
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "nvim-lsp", max_item_count = 5 },
        { name = "luasnip", max_item_count = 3 },
        { name = "treesitter", max_item_count = 4 },
        { name = "nvim_lsp_signature_help", max_item_count = 3 },
        { name = "dap", max_item_count = 5 },
        { name = "rg", max_item_count = 3 },
        { name = "env", max_item_count = 4 },
        { name = "buffer", max_item_count = 5 },
        { name = "path", max_item_count = 4 },
        { name = "otter", max_item_count = 3 },
        { name = "snippy", max_item_count = 4 },
        { name = "calc", max_item_count = 3 },
        { name = "cmdline", max_item_count = 3 },
        { name = "ctags", max_item_count = 3 },
        { name = "color_names", max_item_count = 3 },
      }))
      opts.formatting = opts.formatting or {}
      table.insert(opts.formatting, {
        fields = { "abbr", "kind", "menu" },
        format = require("lspkind").cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
        }),
      })
      opts.completion = vim.tbl_extend("force", opts.completion or {}, {
        completeopt = "menuone,menu,noselect,noinsert",
      })
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
  { "Saecki/crates.nvim", dependencies = { ncmp }, ft = "rust" },
  { "bydlw98/cmp-env", dependencies = { ncmp } },
  { "nat-418/cmp-color-names.nvim", dependencies = { ncmp } },
  { "jc-doyle/cmp-pandoc-references", dependencies = { ncmp } },
  { "saadparwaiz1/cmp_luasnip", dependencies = { ncmp } },
}
