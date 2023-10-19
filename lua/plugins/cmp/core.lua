---@diagnostic disable: missing-fields
local ncmp = "hrsh7th/nvim-cmp"
local default_sources = require("environment.cmp").default_sources
local kenv = require("environment.keys").completion

local function toggle_cmp_enabled()
  local status = vim.b.enable_cmp_completion or vim.g.enable_cmp_completion
  status = not status
  vim.notify(("nvim-cmp: %s"):format(status and "enabled" or "disabled"))
  vim.b.enable_cmp_completion = status
end

local function toggle_cmp_autocompletion()
  local status = vim.b.enable_cmp_autocompletion
    or vim.g.enable_cmp_autocompletion
  status = not status
  if status then
    require("cmp").setup.buffer({
      completion = {
        autocomplete = {
          require("cmp.types").cmp.TriggerEvent.InsertEnter,
          require("cmp.types").cmp.TriggerEvent.TextChanged,
        },
      },
    })
  else
    require("cmp").setup.buffer({
      autocomplete = false,
    })
  end
  vim.b.enable_cmp_autocompletion = status
  vim.notify(("Autocompletion: %s"):format(vim.b.enable_cmp_autocompletion))
end

local function initialize_autocompletion()
  if vim.g.enable_cmp_autocompletion then
    return {
      require("cmp.types").cmp.TriggerEvent.InsertEnter,
      require("cmp.types").cmp.TriggerEvent.TextChanged,
    }
  end
  return false
end

return {
  {
    ncmp,
    version = false,
    dependencies = {
      "L3MON4D3/LuaSnip",
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
    },
    init = function()
      vim.g.enable_cmp_completion = true
      vim.g.enable_cmp_autocompletion = false
    end,
    opts = function(_, opts)
      opts = opts or {}
      opts.enabled = opts.enabled
        or function()
          return vim.b.enable_cmp_completion or vim.g.enable_cmp_completion
        end
      local cmp = require("cmp")
      opts.snippet = vim.tbl_deep_extend("force", {
        expand = function(args)
          require("luasnip").lsp_expand(args)
        end,
      }, opts.snippet or {})
      opts.performance = vim.tbl_deep_extend("force", {
        debounce = 100,
        max_view_entries = 500,
      }, opts.performance or {})

      -- configure nvim-cmp sources.
      -- TODO: integrate a completion menu system that can filter these by first
      -- items on the initialization of the menu.

      opts.sources = vim.list_extend(opts.sources or {}, default_sources)

      -- =======================================================================
      -- The following changes the behavior of the menu. Noteably, we are
      -- turning off autocompletion on insert, in other words we need to hit one
      -- of the configured keys to be able to use the completion menu.
      opts.completion = vim.tbl_deep_extend("force", {
        -- autocomplete = false,
        autocomplete = initialize_autocompletion(),
        scrolloff = true,
      }, opts.completion or {})

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
          { name = "rg" },
        },
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
          { name = "plugins", group_index = 2 },
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
    keys = {
      {
        kenv.toggle.enabled,
        toggle_cmp_enabled,
        mode = "n",
        desc = "cmp=> toggle nvim-cmp enabled",
      },
      {
        kenv.toggle.autocompletion,
        toggle_cmp_autocompletion,
        mode = "n",
        desc = "cmp=> toggle autocompletion on insert",
      },
    },
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
    opts = {},
  },
  { "hrsh7th/cmp-emoji", dependencies = { ncmp } },
  { "chrisgrieser/cmp-nerdfont", dependencies = { ncmp } },
  { "davidmh/cmp-nerdfonts", dependencies = { ncmp } },
  { "amarakon/nvim-cmp-fonts", dependencies = { ncmp } },
  { "f3fora/cmp-spell", dependencies = { ncmp } },
  { "jcha0713/cmp-tw2css", dependencies = { ncmp } },
  {
    "Gelio/cmp-natdat",
    config = function(_, opts)
      require("cmp_natdat").setup()
    end,
    dependencies = { ncmp },
  },
}
