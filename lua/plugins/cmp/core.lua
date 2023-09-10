local ncmp = "hrsh7th/nvim-cmp"
local env = require("environment.ui")
local key_cmp = require("environment.keys").stems.cmp

local function toggle_cmp_enabled()
  local status
  if not vim.fn.exists("b:enable_cmp_completion") then
    status = not vim.g.enable_cmp_completion
  else
    status = not vim.b.enable_cmp_completion
  end
  vim.notify(("nvim-cmp: %s"):format(status))
  vim.b.enable_cmp_completion = status
end

local function toggle_cmp_autocompletion()
  local status
  if not vim.fn.exists("b:enable_cmp_autocompletion") then
    status = not vim.g.enable_cmp_autocompletion
  else
    status = not vim.b.enable_cmp_autocompletion
  end
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

local function kf(key, persisted_ctrl)
  persisted_ctrl = persisted_ctrl or true
  local strfmt
  if persisted_ctrl then
    strfmt = "%s<C-%s>"
  else
    strfmt = "%s%s"
  end
  return string.format(strfmt, key_cmp, key)
end

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
      -- "onsails/lspkind.nvim",
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
      -- "uga-rosa/cmp-dynamic",
      "uga-rosa/cmp-dictionary",
      "f3fora/cmp-spell",
      "jcha0713/cmp-tw2css",
      "barklan/cmp-gitlog",
      "uga-rosa/cmp-latex-symbol",
      "octaltree/cmp-look",
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
      local t_cmp = require("cmp.types")
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_snipmate").lazy_load()
      -- configure the display parameters for teh window, in particular
      -- changing the border and border padding options.
      opts.sources = opts.sources or {}
      opts.performance = vim.tbl_deep_extend("force", {
        debounce = 100,
        max_view_entries = 200,
      }, opts.performance or {})

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
      local default_sources = {
        {
          name = "nvim_lsp",
          entry_filter = function(entry, ctx)
            local kind = t_cmp.lsp.CompletionItemKind[entry:get_kind()]

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
        -- {
        --   name = "dynamic",
        --   group_index = 1,
        -- },
        {
          name = "rg",
          keyword_length = 4,
          group_index = 3,
        },
        {
          name = "env",
          trigger_characters = { "$" },
          group_index = 3,
        },
        {
          name = "buffer",
          keyword_length = 5,
          group_index = 4,
        },
        {
          name = "spell",
          group_index = 2,
        },
        {
          name = "fuzzy_path",
          keyword_length = 3,
          trigger_characters = { "/" },
          group_index = 3,
        },
        {
          name = "gitlog",
          max_item_count = 5,
          group_index = 2,
        },
        {
          name = "calc",
          group_index = 2,
        },
        {
          name = "emoji",
          trigger_characters = { ":" },
          group_index = 2,
        },
        {
          name = "nerdfont",
          trigger_characters = { ":" },
          group_index = 2,
        },
        {
          name = "nerdfonts",
          trigger_characters = { "nf" },
          group_index = 2,
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
          group_index = 2,
        },
      }
      vim.list_extend(opts.sources, default_sources)

      -- -────────────────────────────────────────────────────────────---------
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

      -- main mappings for nvim cmp. These define both the standard-esque
      -- behavior that should be the default completion popup and matching
      -- behavior for normal completion, as well as the specifically made
      -- submenus with more semantic meaning behind them for more directed
      -- completion results from specific sources.
      opts.mapping =
        require("cmp").mapping.preset.insert(vim.tbl_deep_extend("force", {
          ["<CR>"] = require("cmp").mapping({
            i = function(fallback)
              if
                require("cmp").visible() and require("cmp").get_active_entry()
              then
                require("cmp").mapping.confirm({
                  behavior = require("cmp").ConfirmBehavior.Replace,
                  select = false,
                })
              else
                fallback()
              end
            end,
            s = require("cmp").mapping.confirm({ select = true }),
            c = require("cmp").mapping.confirm({
              behavior = require("cmp").ConfirmBehavior.Replace,
              select = false,
            }),
          }),
          ["<Tab>"] = require("lsp-zero").cmp_action().luasnip_supertab(),
          ["<S-Tab>"] = require("lsp-zero")
            .cmp_action()
            .luasnip_shift_supertab(),
          ["<A-[>"] = require("lsp-zero").cmp_action().luasnip_jump_backward(),
          ["<A-]>"] = require("lsp-zero").cmp_action().luasnip_jump_forward(),
          ["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
          ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
          ["<C-x>"] = require("cmp").mapping.complete_common_string(),
          ["<C-y>"] = require("cmp").mapping({
            i = function(fallback)
              if
                require("cmp").visible() and require("cmp").get_active_entry()
              then
                require("cmp").mapping.confirm({
                  behavior = require("cmp").ConfirmBehavior.Replace,
                  select = false,
                })
              else
                fallback()
              end
            end,
          }),
          ["<C-e>"] = require("cmp").mapping({
            i = function(fallback)
              if require("cmp").visible() then
                require("cmp").abort()
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
          [kf("a")] = require("cmp").mapping({
            i = function(fallback)
              if
                not require("cmp").mapping.complete({
                  config = {
                    sources = require("cmp").config.sources({
                      { name = "codeium" },
                      { name = "cmp_tabnine" },
                    }),
                  },
                })
              then
                fallback()
              end
            end,
          }),
          [kf("g")] = require("cmp").mapping({
            i = function(fallback)
              if
                not require("cmp").mapping.complete({
                  config = {
                    sources = require("cmp").mapping.sources({
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
          }),
          [kf("s")] = require("cmp").mapping({
            i = function(fallback)
              if
                not require("cmp").mapping.complete({
                  config = {
                    sources = require("cmp").config.sources({
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
          }),
          [kf("i")] = require("cmp").mapping({
            i = function(fallback)
              if
                not require("cmp").mapping.complete({
                  config = {
                    sources = require("cmp").config.sources({
                      {
                        name = "fonts",
                        option = { space_filter = "-" },
                      },
                      { name = "nerdfont" },
                      { name = "emoji" },
                    }),
                  },
                })
              then
                fallback()
              end
            end,
          }),
          [kf("l")] = require("cmp").mapping({
            i = function(fallback)
              if
                not require("cmp").mapping.complete({
                  config = {
                    sources = require("cmp").config.sources({
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
          }),
          [kf(".")] = require("cmp").mapping({
            i = function(fallback)
              if
                not require("cmp").mapping.complete({
                  config = {
                    sources = require("cmp").config.sources({
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
            end,
          }),
          [kf(":")] = require("cmp").mapping({
            i = function(fallback)
              if
                not require("cmp").mapping.complete({
                  config = {
                    sources = require("cmp").config.sources({
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
          }),
        }, opts.mapping or {}))
    end,
    keys = {
      {
        "<leader>uxe",
        toggle_cmp_enabled,
        mode = "n",
        desc = "cmp=> toggle nvim-cmp enabled",
      },
      {
        "<leader>uxc",
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
  -- --------------
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
  -- { "uga-rosa/cmp-dynamic", dependencies = { ncmp } },
  { "uga-rosa/cmp-dictionary", dependencies = { ncmp } },
  { "barklan/cmp-gitlog", dependencies = { ncmp } },

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

  -- Next, AI tooling...these are selectively available but I'm not sure how to fix that.
  -- TODO figure out the above and determine what to do to fix the issue.
  { "tzachar/cmp-ai", optional = true, dependencies = { ncmp } },
  { "jcdickinson/codeium.nvim", optional = true, dependencies = { ncmp } },
  { "zbirenbaum/copilot-cmp", optional = true, dependencies = { ncmp } },
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
}
