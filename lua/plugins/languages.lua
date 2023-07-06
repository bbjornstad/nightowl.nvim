local key_neogen = require("environment.keys").stems.neogen
local key_iron = require("environment.keys").stems.iron
local mapn = require("environment.keys").map("n")
local toggle_fmtoption = require("uutils.edit").toggle_fmtopt

return {
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      {
        "rust-lang/rust.vim",
        config = function() end,
      },
    },
    ft = { "rust" },
    opts = function(_, opts)
      opts.tools = vim.tbl_extend("force", {
        inlay_hints = {
          auto = true,
        },
      }, opts.tools or {})
      opts.server = vim.tbl_extend("force", {
        on_attach = function(_, bufnr)
          vim.keymap.set(
            { "n" },
            "<leader>ca",
            rust_tools.hover_actions.hover_actions,
            {
              buffer = bufnr,
              desc = "lsp=> rust code actions for symbol",
            }
          )
        end,
      }, opts.server or {})
    end,
  },
  { "lervag/vimtex", ft = { "tex" } },
  { "jmcantrell/vim-virtualenv", ft = { "python" } },
  {
    "lepture/vim-jinja",
    ft = { "jinja", "j2", "jinja2", "tfy" },
    dependencies = {
      "Glench/Vim-Jinja2-Syntax",
      ft = { "jinja", "j2", "jinja2", "tfy" },
    },
  },
  {
    "saltstack/salt-vim",
    ft = { "Saltfile", "sls", "top" },
    dependencies = { "Glench/Vim-Jinja2-Syntax", "lepture/vim-jinja" },
  },
  {
    "preservim/vim-markdown",
    ft = { "markdown", "md", "rmd" },
    init = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_json_frontmatter = 1
    end,
  },
  { "SidOfc/mkdx", ft = { "markdown", "md" } },
  {
    "danymat/neogen",
    event = { "VeryLazy" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { snippet_engine = "luasnip" },
    init = function()
      mapn(key_neogen .. "d", function()
        return require("neogen").generate({ type = "func" })
      end, { desc = "docs=> generate function docstring" })
      mapn(key_neogen .. "c", function()
        return require("neogen").generate({ type = "class" })
      end, { desc = "docs=> generate class docstring" })
      mapn(key_neogen .. "t", function()
        return require("neogen").generate({ type = "type" })
      end, { desc = "docs=> generate type docstring" })
      mapn(key_neogen .. "f", function()
        return require("neogen").generate({ type = "func" })
      end, { desc = "docs=> generate function docstring" })
    end,
  },
  { "Fymyte/rasi.vim", ft = { "rasi" } },
  {
    "hkupty/iron.nvim",
    tag = "v3.0",
    module = "iron.core",
    opts = {
      config = {
        repl_open_cmd = ":lua require('iron.view').split.vertical.botright(50)",
        scratch_repl = true,
        repl_definition = { sh = { command = { "zsh" } } },
      },
      keymaps = {},
    },
    init = function()
      mapn(key_iron .. "s", function()
        local core = require("iron.core")
        local ft = vim.bo.filetype
        core.repl_here(ft)
      end, { desc = "iron=> open repl" })
      mapn(key_iron .. "r", function()
        local core = require("iron.core")
        core.repl_restart()
      end, { desc = "iron=> restart repl" })
      mapn(key_iron .. "f", function()
        local core = require("iron.core")
        local ft = vim.bo.filetype
        core.focus_on(ft)
      end, { desc = "iron=> focus" })
      mapn(key_iron .. "h", function()
        local core = require("iron.core")
        local ft = vim.bo.filetype
        core.close_repl(ft)
      end, { desc = "iron=> hide" })
    end,
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "hrsh7th/nvim-cmp",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "qmd" },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      if vim.fn.has("otter") then
        opts.sources = vim.list_extend({
          { name = "otter", max_item_count = 8 },
        }, opts.sources or {})
      end
    end,
  },
  {
    "LhKipp/nvim-nu",
    build = [[:TSInstall nu]],
    ft = { "nu" },
    opts = {
      use_lsp_features = true,
      all_cmd_names = [[nu -c 'help commands | get name | str join "\n"']],
    },
    config = true,
  },
  {
    "Shopify/shadowenv.vim",
    config = function() end,
    ft = { "lisp" },
  },
  {
    "guns/vim-sexp",
    config = function() end,
    ft = { "lisp" },
  },
  {
    "cuducos/yaml.nvim",
    ft = { "yaml" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = function(_, opts)
      require("telescope").load_extension("yaml_schema")
      opts.lspconfig = vim.tbl_extend("force", {
        settings = {
          yaml = {
            format = {
              prosewrap = "Preserve",
            },
          },
        },
      }, opts.lspconfig or {})
    end,
    init = function()
      toggle_fmtoption("l")
      vim.opt.formatoptions = vim.opt.formatoptions + "o"
      mapn(
        "<leader>mm",
        require("yaml-companion").open_ui_select,
        { desc = "schema=> select YAML schemas" }
      )
    end,
  },
  {
    "jbyuki/nabla.nvim",
    ft = { "markdown", "md" },
  },
}
