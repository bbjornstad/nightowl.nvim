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
    -- group_index = 1,
  },
  {
    name = "nvim_lsp_signature_help",
    -- group_index = 1,
  },
  {
    name = "nvim_lsp_document_symbol",
    -- group_index = 1,
  },
  -- {
  --   name = "treesitter",
  --   keyword_length = 4,
  --   -- group_index = 1,
  -- },
  {
    name = "luasnip",
    keyword_length = 3,
    -- group_index = 1,
  },
  {
    name = "dap",
    -- group_index = 1,
  },
  {
    name = "ctags",
    -- group_index = 1,
  },
  {
    name = "look",
    option = {
      convert_case = true,
      loud = true,
    },
    -- group_index = 1,
  },
  {
    name = "omni",
    option = {
      disable_omnifuncs = { "v:lua.vim.lsp.omnifunc" },
    },
    -- group_index = 1,
  },
  {
    name = "rg",
    keyword_length = 4,
    -- group_index = 2,
  },
  {
    name = "env",
    trigger_characters = { "$" },
    -- group_index = 2,
  },
  {
    name = "dotenv",
    option = {
      path = ".",
      load_shell = true,
      item_kind = require("cmp").lsp.CompletionItemKind.Variable,
      eval_on_confirm = false,
      show_documentation = true,
      show_content_on_docs = true,
      documentation_kind = "markdown",
      dotenv_environment = ".*",
      file_priority = function(a, b)
        return a.upper() < b.upper()
      end,
    },
    -- group_index = 1,
  },
  {
    name = "buffer",
    keyword_length = 5,
    -- group_index = 3,
  },
  {
    name = "async_path",
    keyword_length = 2,
    trigger_characters = { "/" },
  },
  {
    name = "gitlog",
    max_item_count = 5,
    -- group_index = 2,
  },
  {
    name = "calc",
    -- group_index = 1,
  },
  {
    name = "emoji",
    trigger_characters = { ":" },
    -- group_index = 1,
  },
  {
    name = "nerdfont",
    trigger_characters = { ":" },
    -- group_index = 1,
  },
  {
    name = "fonts",
    -- group_index = 2,
    keyword_length = 3,
    option = { space_filter = "-" },
  },
  {
    name = "diag-codes",
    option = { in_comment = false },
    -- group_index = 1,
  },
  {
    name = "natdat",
    -- group_index = 1,
  },
  {
    name = "codeium",
    -- group_index = 1,
  },
  {
    name = "tabnine",
    -- group_index = 1,
  },
  {
    name = "copilot",
    -- group_index = 1,
  },
  {
    name = "cmp_ai",
    -- group_index = 1,
  },
}

return {
  {
    ncmp,
    version = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      -- "tzachar/cmp-fuzzy-path",
      "FelipeLema/cmp-async-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-emoji",
      "lukas-reineke/cmp-rg",
      "delphinus/cmp-ctags",
      "rcarriga/cmp-dap",
      "hrsh7th/cmp-calc",
      "bydlw98/cmp-env",
      "SergioRibera/cmp-dotenv",
      "amarakon/nvim-cmp-fonts",
      "chrisgrieser/cmp-nerdfont",
      "saadparwaiz1/cmp_luasnip",
      "JMarkin/cmp-diag-codes",
      "Gelio/cmp-natdat",
      "hrsh7th/cmp-omni",
      "octaltree/cmp-look",
      { "tzachar/cmp-tabnine", optional = true },
      { "tzachar/cmp-ai", optional = true },
      { "Exafunction/codeium.nvim", optional = true },
      { "zbirenbaum/copilot-cmp", optional = true },
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
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
          { name = "async_path" },
          { name = "rg" },
          { name = "env" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Next we have filetype specific completion sources, these should be
      -- added only when needed.
      cmp.setup.filetype({ "rust", "cargo" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "crates",
            -- group_index = 1,
          },
        }),
      })
      cmp.setup.filetype(
        { "gitconfig", "gitcommit", "gitattributes", "gitignore", "gitrebase" },
        {
          sources = vim.list_extend(vim.deepcopy(default_sources), {
            {
              name = "git",
              -- group_index = 1,
            },
            {
              name = "conventionalcommits",
              -- group_index = 1,
            },
            {
              name = "commit",
              -- group_index = 1,
            },
            {
              name = "gitcommit",
              -- group_index = 1,
            },
            {
              name = "gitlog",
              -- group_index = 1,
              max_item_count = 5,
            },
          }),
        }
      )
      cmp.setup.filetype({ "css" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "cmp-tw2css",
            -- group_index = 1,
          },
        }),
      })
      cmp.setup.filetype({ "sass", "scss" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "sass-variables",
            -- group_index = 1,
          },
          {
            name = "cmp-tw2css",
            -- group_index = 1,
          },
        }),
      })
      cmp.setup.filetype({ "lua" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "nvim_lua",
            -- group_index = 1,
          },
          {
            name = "plugins",
            -- group_index = 1,
          },
        }),
      })
      cmp.setup.filetype({ "clojure", "fennel", "python" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "conjure",
            -- group_index = 1,
          },
        }),
      })

      cmp.setup.filetype({
        "html",
        "css",
        "js",
        "md",
        "org",
        "norg",
        "scss",
        "sass",
      }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "color_names",
          },
        }),
      })

      cmp.setup.filetype(
        { "markdown", "rmd", "quarto", "org", "norg", "latex", "tex", "bibtex" },
        {
          sources = vim.list_extend(vim.deepcopy(default_sources), {
            {
              name = "otter",
              -- group_index = 1,
            },
            {
              name = "pandoc-references",
              -- group_index = 1,
            },
            {
              name = "dictionary",
              -- group_index = 1,
            },
            {
              name = "spell",
              -- group_index = 1,
            },
            {
              name = "latex_symbols",
              -- group_index = 1,
            },
          }),
        }
      )
      cmp.setup.filetype({ "latex", "tex", "bibtex" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "vimtex",
            -- group_index = 1,
          },
        }),
      })
      cmp.setup.filetype({ "neorg", "norg" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "neorg",
            -- group_index = 1,
          },
        }),
      })
      cmp.setup.filetype({ "orgmode", "org" }, {
        sources = vim.list_extend(vim.deepcopy(default_sources), {
          {
            name = "orgmode",
            -- group_index = 1,
          },
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
  { "FelipeLema/cmp-async-path", optional = true, dependencies = { ncmp } },
  -- {
  --   "tzachar/cmp-fuzzy-path",
  --   dependencies = { ncmp, "tzachar/fuzzy.nvim" },
  -- },
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
  { "ray-x/cmp-treesitter", optional = true, dependencies = { ncmp } },
  { "bydlw98/cmp-env", dependencies = { ncmp } },
  { "SergioRibera/cmp-dotenv", dependencies = { ncmp } },
  { "saadparwaiz1/cmp_luasnip", dependencies = { ncmp } },
  { "JMarkin/cmp-diag-codes", dependencies = { ncmp } },
  { "octaltree/cmp-look", dependencies = { ncmp } },
  {
    "uga-rosa/cmp-dictionary",
    ft = {
      "markdown",
      "rmd",
      "quarto",
      "org",
      "norg",
      "latex",
      "tex",
      "bibtex",
    },
    dependencies = { ncmp },
  },
  { "hrsh7th/cmp-omni", dependencies = { ncmp } },

  -- Next Up: Filetype Specific
  -- git
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
    ft = {
      "markdown",
      "rmd",
      "quarto",
      "org",
      "norg",
      "latex",
      "tex",
      "bibtex",
    },
    dependencies = { ncmp },
  },
  { "KadoBOT/cmp-plugins", ft = { "lua" }, dependencies = { ncmp } },
  {
    "kdheepak/cmp-latex-symbols",
    ft = {
      "markdown",
      "rmd",
      "quarto",
      "org",
      "norg",
      "latex",
      "tex",
      "bibtex",
    },
    dependencies = { ncmp },
  },

  {
    "micangl/cmp-vimtex",
    optional = true,
    dependencies = { ncmp },
    ft = { "latex", "tex", "bibtex" },
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
    ft = { "html", "css", "js", "md", "org", "norg", "scss", "sass" },
  },
  { "hrsh7th/cmp-emoji", dependencies = { ncmp } },
  { "chrisgrieser/cmp-nerdfont", dependencies = { ncmp } },
  { "amarakon/nvim-cmp-fonts", dependencies = { ncmp } },
  {
    "f3fora/cmp-spell",
    ft = {
      "markdown",
      "rmd",
      "quarto",
      "org",
      "norg",
      "latex",
      "tex",
      "bibtex",
    },
    dependencies = { ncmp },
  },
  {
    "jcha0713/cmp-tw2css",
    ft = { "sass", "scss", "css" },
    dependencies = { ncmp },
  },
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
  {},
}
