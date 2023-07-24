local env = require("environment.ui")
local kenv = require("environment.keys")
local key_neogen = kenv.stems.neogen
local key_iron = kenv.stems.iron
local key_rest = kenv.stems.rest
local mapn = kenv.map("n")
local toggle_fmtoption = require("uutils.edit").toggle_fmtopt

return {
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = {
      tools = {
        inlay_hints = {
          auto = true,
          max_len_align = true,
        },
        hover_actions = {
          border = env.borders.main,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = vim.tbl_deep_extend("force", {
        rust_analyzer = {
          keys = {
            {
              "K",
              function()
                require("rust-tools").hover_actions.hover_actions()
              end,
              desc = "lsp=> hover (rust edition)",
            },
            {
              "<leader>a",
              function()
                require("rust-tools").code_action_group.code_action_group()
              end,
              desc = "lsp=> code actions (rust edition)",
            },
          },
        },
      }, opts.servers or {})
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
  {
    "SidOfc/mkdx",
    ft = { "markdown", "md" },
    config = function()
      vim.cmd(
        [[let g:mkdx#settings = { 'highlight': { 'frontmatter': { 'toml': 1 } } }]]
      )
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    config = true,
    opts = {
      modules = {
        bib = true,
        buffers = true,
        conceal = true,
        cursor = true,
        folds = true,
        links = true,
        lists = true,
        maps = true,
        paths = true,
        tables = true,
        yaml = true,
      },
      filetypes = { "md", "markdown", "rmd", "qmd" },
      create_dirs = true,
      perspective = {
        priority = "first",
        fallback = "current",
        root_tell = false,
        nvim_wd_heel = false,
        update = false,
      },
      wrap = false,
      bib = {
        default_path = nil,
        find_in_root = true,
      },
      silent = false,
      links = {
        style = "markdown",
        name_is_source = false,
        conceal = false,
        context = 0,
        implicit_extension = nil,
        transform_implicit = false,
        transform_explicit = function(text)
          text = text:gsub(" ", "-")
          text = text:lower()
          text = os.date("%Y-%m-%d_") .. text
          return text
        end,
      },
      new_file_template = {
        use_template = false,
        placeholders = {
          before = {
            title = "link_title",
            date = "os_date",
          },
          after = {},
        },
        template = "# {{ title }}",
      },
      to_do = {
        symbols = { " ", "-", "X" },
        update_parents = true,
        not_started = " ",
        in_progress = "-",
        complete = "X",
      },
      tables = {
        trim_whitespace = true,
        format_on_move = true,
        auto_extend_rows = false,
        auto_extend_cols = false,
      },
      yaml = {
        bib = { override = false },
      },
      mappings = {
        MkdnEnter = { { "n", "v" }, "<CR>" },
        MkdnTab = false,
        MkdnSTab = false,
        MkdnNextLink = { "n", "<Tab>" },
        MkdnPrevLink = { "n", "<S-Tab>" },
        MkdnNextHeading = { "n", "]]" },
        MkdnPrevHeading = { "n", "[[" },
        MkdnGoBack = { "n", "<BS>" },
        MkdnGoForward = { "n", "<Del>" },
        MkdnCreateLink = false, -- see MkdnEnter
        MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>p" }, -- see MkdnEnter
        MkdnFollowLink = false, -- see MkdnEnter
        MkdnDestroyLink = { "n", "<M-CR>" },
        MkdnTagSpan = { "v", "<M-CR>" },
        MkdnMoveSource = { "n", "<F2>" },
        MkdnYankAnchorLink = { "n", "yaa" },
        MkdnYankFileAnchorLink = { "n", "yfa" },
        MkdnIncreaseHeading = { "n", "+" },
        MkdnDecreaseHeading = { "n", "-" },
        MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = { "n", "o" },
        MkdnNewListItemAboveInsert = { "n", "O" },
        MkdnExtendList = false,
        MkdnUpdateNumbering = { "n", "<leader>nn" },
        MkdnTableNextCell = { "i", "<Tab>" },
        MkdnTablePrevCell = { "i", "<S-Tab>" },
        MkdnTableNextRow = false,
        MkdnTablePrevRow = { "i", "<M-CR>" },
        MkdnTableNewRowBelow = { "n", "<leader>ir" },
        MkdnTableNewRowAbove = { "n", "<leader>iR" },
        MkdnTableNewColAfter = { "n", "<leader>ic" },
        MkdnTableNewColBefore = { "n", "<leader>iC" },
        MkdnFoldSection = { "n", "<leader>f" },
        MkdnUnfoldSection = { "n", "<leader>F" },
      },
    },
  },
  {
    "jghauser/auto-pandoc.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
    opts = {},
    keys = {
      {
        "<leader>Do",
        "<CMD>silent w<bar> lua require('auto-pandoc').run_pandoc()<CR>",
        mode = "n",
        desc = "docs=> convert with pandoc",
        buffer = 0,
        noremap = true,
        silent = true,
      },
    },
  },
  {
    "danymat/neogen",
    event = { "VeryLazy" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = { snippet_engine = "luasnip" },
    keys = {
      {
        key_neogen .. "d",
        function()
          return require("neogen").generate({ type = "func" })
        end,
        mode = "n",
        desc = "gendoc=> function docstring",
      },
      {
        key_neogen .. "c",
        function()
          return require("neogen").generate({ type = "class" })
        end,
        mode = "n",
        desc = "gendoc=> class/obj docstring",
      },
      {
        key_neogen .. "t",
        function()
          return require("neogen").generate({ type = "type" })
        end,
        mode = "n",
        desc = "gendoc=> type docstring",
      },
      {
        key_neogen .. "f",
        function()
          return require("neogen").generate({ type = "func" })
        end,
        mode = "n",
        desc = "gendoc=> function docstring",
      },
    },
  },
  { "Fymyte/rasi.vim", ft = { "rasi" } },
  {
    "Vigemus/iron.nvim",
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
    keys = {
      {
        key_iron .. "s",
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.repl_here(ft)
        end,
        mode = "n",
        desc = "iron=> open ft repl",
      },
      {
        key_iron .. "r",
        function()
          local core = require("iron.core")
          core.repl_restart()
        end,
        mode = "n",
        desc = "iron=> restart repl",
      },
      {
        key_iron .. "f",
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.focus_on(ft)
        end,
        mode = "n",
        desc = "iron=> focus on repl",
      },
      {
        key_iron .. "q",
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.close_repl(ft)
        end,
        mode = "n",
        desc = "iron=> hide repl",
      },
    },
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
          opts.sources = vim.list_extend({
            { name = "otter", max_item_count = 8 },
          }, opts.sources or {})
        end,
      },
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "qmd" },
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
        "<leader>M",
        require("yaml-companion").open_ui_select,
        { desc = "schema=> select YAML schemas" }
      )
    end,
  },
  {
    "jbyuki/nabla.nvim",
    config = false,
    ft = { "markdown", "md" },
  },
  {
    "joelbeedle/pseudo-syntax",
    ft = { "pseudo" },
    config = false,
  },
  {
    "bennypowers/nvim-regexplainer",
    config = true,
    opts = {
      popup = {
        border = {
          style = env.borders.main,
          padding = { 1, 2 },
        },
      },
    },
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "tomiis4/hypersonic.nvim",
    config = true,
    opts = {
      border = env.borders.main,
      winblend = 15,
      add_padding = true,
      hl_group = "Keyword",
      wrapping = '"',
      enable_cmdline = true,
    },
    event = "VeryLazy",
    keys = {},
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Keep the http file buffer above|left when split horizontal|vertical
      result_split_in_place = false,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Encode URL before making request
      encode_url = true,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        -- show the generated curl command in case you want to launch
        -- the same request via the terminal (can be verbose)
        show_curl_command = true,
        show_http_info = true,
        show_headers = true,
        -- executables or functions for formatting response body [optional]
        -- set them to false if you want to disable them
        formatters = {
          json = "jq",
          html = function(body)
            return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
          end,
        },
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = ".env",
      custom_dynamic_variables = {},
      yank_dry_run = true,
    },
    config = true,
    cmd = { "RestNvim", "RestNvimPreview", "RestNvimLast" },
    keys = {
      {
        key_rest .. "r",
        "<Plug>RestNvim",
        mode = "n",
        desc = "rest=> open rest client",
        remap = true,
      },
      {
        key_rest .. "p",
        "<Plug>RestNvimPreview",
        mode = "n",
        desc = "rest=> open rest preview",
        remap = true,
      },
      {
        key_rest .. "l",
        "<Plug>RestNvimLast",
        mode = "n",
        desc = "rest=> open last used rest client",
        remap = true,
      },
    },
  },
  {
    "gaoDean/autolist.nvim",
    ft = {
      "markdown",
      "text",
      "tex",
      "plaintex",
      "norg",
      "org",
      r,
    },
    config = function()
      require("autolist").setup()

      vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
      vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
      -- vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
      vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
      vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
      vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

      -- cycle list types with dot-repeat
      vim.keymap.set(
        "n",
        "<leader>cn",
        require("autolist").cycle_next_dr,
        { expr = true }
      )
      vim.keymap.set(
        "n",
        "<leader>cp",
        require("autolist").cycle_prev_dr,
        { expr = true }
      )

      -- if you don't want dot-repeat
      -- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
      -- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

      -- functions to recalculate list on edit
      vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
      vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
      vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
      vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
    end,
  },
  {
    "clojure-vim/acid.nvim",
    config = function() end,
    build = ":UpdateRemotePlugins",
  },
  {
    "arsham/archer.nvim",
    event = "VeryLazy",
    dependencies = { "arsham/arshlib.nvim" },
    config = true,
  },
}
