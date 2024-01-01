---@diagnostic disable: missing-fields
local ncmp = "hrsh7th/nvim-cmp"
local default_sources = {
  {
    name = "nvim_lsp",
    entry_filter = function(entry, ctx)
      local kind = require("cmp.types").lsp.CompletionItemKind[entry:get_kind()]

      if kind == "Text" then
        return false
      end
      return true
    end,
    group_index = 1,
  },
  {
    name = "nvim_lsp_signature_help",
    group_index = 1,
  },
  {
    name = "nvim_lsp_document_symbol",
    group_index = 1,
  },
  {
    name = "treesitter",
    keyword_length = 4,
    group_index = 1,
  },
  {
    name = "luasnip",
    group_index = 1,
  },
  {
    name = "dap",
    group_index = 1,
  },
  {
    name = "ctags",
    group_index = 1,
  },
  -- {
  --   name = "dynamic",
  --   group_index = 1,
  -- },
  {
    name = "look",
    option = {
      convert_case = true,
      loud = true,
    },
    group_index = 1,
  },
  {
    name = "omni",
    option = {
      disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
    },
    group_index = 1,
  },
  {
    name = "rg",
    keyword_length = 4,
    group_index = 2,
  },
  {
    name = "env",
    trigger_characters = { "$" },
    group_index = 3,
  },
  {
    name = "buffer",
    keyword_length = 5,
    group_index = 3,
  },
  {
    name = "spell",
    group_index = 2,
  },
  {
    name = "fuzzy_path",
    keyword_length = 3,
    trigger_characters = { "/" },
    group_index = 2,
  },
  {
    name = "gitlog",
    max_item_count = 5,
    group_index = 2,
  },
  {
    name = "calc",
    group_index = 1,
  },
  {
    name = "digraphs",
    option = {
      cache_digraphs_on_start = true,
    },
    group_index = 2,
  },
  {
    name = "emoji",
    trigger_characters = { ":" },
    group_index = 1,
  },
  {
    name = "nerdfont",
    trigger_characters = { ":" },
    group_index = 1,
  },
  {
    name = "nerdfonts",
    trigger_characters = { "nf" },
    group_index = 1,
  },
  {
    name = "color_names",
    group_index = 2,
  },
  {
    name = "fonts",
    group_index = 2,
    keyword_length = 3,
    option = { space_filter = "-" },
  },
  {
    name = "diag-codes",
    option = { in_comment = false },
    group_index = 1,
  },
  {
    name = "natdat",
    group_index = 1,
  },
  {
    name = "codeium",
    group_index = 1,
  },
  {
    name = "tabnine",
    group_index = 1,
  },
  {
    name = "copilot",
    group_index = 1,
  },
  {
    name = "cmp_ai",
    group_index = 1,
  },
}

return {
  {
    ncmp,
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "tzachar/cmp-fuzzy-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-emoji",
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
      "amarakon/nvim-cmp-fonts",
      "davidmh/cmp-nerdfonts",
      "chrisgrieser/cmp-nerdfont",
      "saadparwaiz1/cmp_luasnip",
      "KadoBOT/cmp-plugins",
      "JMarkin/cmp-diag-codes",
      "uga-rosa/cmp-dictionary",
      "f3fora/cmp-spell",
      "jcha0713/cmp-tw2css",
      "barklan/cmp-gitlog",
      "uga-rosa/cmp-latex-symbol",
      "Gelio/cmp-natdat",
      "dmitmel/cmp-digraphs",
      "hrsh7th/cmp-omni",
      "octaltree/cmp-look",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts = opts or {}
      -- configure nvim-cmp sources.
      opts.sources = vim.list_extend(opts.sources or {}, default_sources)

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "buffer" },
          { name = "rg" },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "cmdline" },
          { name = "fuzzy_path" },
          { name = "rg" },
          { name = "env" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Next we have filetype specific completion sources, these should be
      -- added only when needed.
      cmp.setup.filetype({ "rust" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "crates", group_index = 1 },
        }),
      })
      cmp.setup.filetype(
        { "gitconfig", "gitcommit", "gitattributes", "gitignore", "gitrebase" },
        {
          sources = vim.list_extend(vim.deepcopy(default_sources), {
            { name = "git", group_index = 1 },
            { name = "conventionalcommits", group_index = 1 },
            { name = "commit", group_index = 1 },
            { name = "gitcommit", group_index = 1 },
            {
              name = "gitlog",
              group_index = 1,
              max_item_count = 5,
            },
          }),
        }
      )
      cmp.setup.filetype({ "css" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "cmp-tw2css", group_index = 1 },
        }),
      })
      cmp.setup.filetype({ "sass", "scss" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "sass-variables", group_index = 1 },
          { name = "cmp-tw2css", group_index = 1 },
        }),
      })
      cmp.setup.filetype({ "lua" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "nvim_lua", group_index = 1 },
          { name = "plugins", group_index = 1 },
        }),
      })
      cmp.setup.filetype({ "clojure", "fennel", "python" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "conjure", group_index = 1 },
        }),
      })

      cmp.setup.filetype(
        { "markdown", "quarto", "org", "norg", "latex", "tex" },
        {
          sources = vim.list_extend(vim.deepcopy(default_sources), {
            { name = "otter", group_index = 1 },
            { name = "pandoc-references", group_index = 1 },
            { name = "dictionary", group_index = 1 },
            { name = "spell", group_index = 1 },
            { name = "latex_symbol", group_index = 1 },
          }),
        }
      )
      cmp.setup.filetype({ "neorg", "norg" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "neorg", group_index = 1 },
        }),
      })
      cmp.setup.filetype({ "orgmode", "org" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          { name = "orgmode", group_index = 1 },
        }),
      })
    end,
  },
  -- explicitly list out the sources that we are installing for nvim-cmp. These
  -- match the list that is represented above, but with the added caveat that
  -- these are required in order to prevent timing mismatches when nvim-cmp
  -- loads upon vim startup.
  -- First Up: Core
  -- ==============
  { "hrsh7th/cmp-buffer", dependencies = { ncmp } },
  { "hrsh7th/cmp-path", dependencies = { ncmp } },
  {
    "tzachar/cmp-fuzzy-path",
    dependencies = { ncmp, "tzachar/fuzzy.nvim" },
  },
  { "hrsh7th/cmp-cmdline", dependencies = { ncmp } },
  {
    "hrsh7th/cmp-nvim-lua",
    dependencies = { ncmp },
    ft = "lua",
  },
  { "hrsh7th/cmp-nvim-lsp-signature-help", dependencies = { ncmp } },
  { "hrsh7th/cmp-nvim-lsp-document-symbol", dependencies = { ncmp } },
  { "lukas-reineke/cmp-rg", dependencies = { ncmp } },
  { "rcarriga/cmp-dap", dependencies = { ncmp } },
  { "hrsh7th/cmp-calc", dependencies = { ncmp } },
  { "ray-x/cmp-treesitter", dependencies = { ncmp } },
  { "bydlw98/cmp-env", dependencies = { ncmp } },
  { "saadparwaiz1/cmp_luasnip", dependencies = { ncmp } },
  { "JMarkin/cmp-diag-codes", dependencies = { ncmp } },
  { "octaltree/cmp-look", dependencies = { ncmp } },
  { "uga-rosa/cmp-dictionary", dependencies = { ncmp } },
  { "barklan/cmp-gitlog", dependencies = { ncmp } },
  { "hrsh7th/cmp-omni", dependencies = { ncmp } },

  -- Next Up: Filetype Specific
  -- -- git
  {
    "petertriho/cmp-git",
    ft = { "gitrebase", "gitcommit", "gitattributes", "gitconfig", "gitignore" },
    dependencies = { ncmp },
  },
  {
    "davidsierradz/cmp-conventionalcommits",
    ft = { "gitrebase", "gitcommit", "gitattributes", "gitconfig", "gitignore" },
    dependencies = { ncmp },
  },
  {
    "Dosx001/cmp-commit",
    ft = { "gitrebase", "gitcommit", "gitattributes", "gitconfig", "gitignore" },
    dependencies = { ncmp },
  },
  {
    "barklan/cmp-gitlog",
    ft = { "gitrebase", "gitcommit", "gitattributes", "gitconfig", "gitignore" },
    dependencies = { ncmp },
  },
  {
    "Cassin01/cmp-gitcommit",
    ft = { "gitrebase", "gitcommit", "gitattributes", "gitconfig", "gitignore" },
    dependencies = { ncmp },
  },
  -- -- shell items
  { "tamago324/cmp-zsh", dependencies = { ncmp }, ft = "zsh" },
  { "mtoohey31/cmp-fish", dependencies = { ncmp }, ft = { "fish" } },
  -- -- other random stuff
  {
    "pontusk/cmp-sass-variables",
    ft = { "sass", "scss" },
    dependencies = { ncmp },
  },
  {
    "jc-doyle/cmp-pandoc-references",
    ft = { "markdown", "quarto", "org", "norg", "latex", "tex" },
    dependencies = { ncmp },
  },
  { "Saecki/crates.nvim", dependencies = { ncmp }, ft = "rust" },
  { "KadoBOT/cmp-plugins", ft = { "lua" }, dependencies = { ncmp } },
  {
    "uga-rosa/cmp-latex-symbol",
    ft = { "markdown", "quarto", "org", "norg", "latex", "tex" },
    dependencies = { ncmp },
  },

  {
    "micangl/cmp-vimtex",
    optional = true,
    dependencies = { ncmp },
    ft = { "latex" },
  },

  -- AI tooling
  { "tzachar/cmp-ai", optional = true, dependencies = { ncmp } },
  { "Exafunction/codeium.nvim", optional = true, dependencies = { ncmp } },
  {
    "zbirenbaum/copilot-cmp",
    optional = true,
    dependencies = { ncmp, "zbirenbaum/copilot.lua" },
  },
  { "tzachar/cmp-tabnine", optional = true, dependencies = { ncmp } },
  -- Lastly: Extra Things
  {
    "nat-418/cmp-color-names.nvim",
    dependencies = { ncmp },
    config = true,
    ft = { "html", "css", "js", "md", "org", "norg" },
  },
  { "hrsh7th/cmp-emoji", dependencies = { ncmp } },
  { "dmitmel/cmp-digraphs", dependencies = { ncmp } },
  { "chrisgrieser/cmp-nerdfont", dependencies = { ncmp } },
  { "davidmh/cmp-nerdfonts", dependencies = { ncmp } },
  { "amarakon/nvim-cmp-fonts", dependencies = { ncmp } },
  { "f3fora/cmp-spell", dependencies = { ncmp } },
  { "jcha0713/cmp-tw2css", dependencies = { ncmp } },
  { "delphinus/cmp-ctags", dependencies = { ncmp } },
  {
    "Gelio/cmp-natdat",
    config = function(_, opts)
      require("cmp_natdat").setup()
    end,
    opts = {
      cmp_kind_text = "[date]",
    },
    dependencies = { ncmp },
  },
}
