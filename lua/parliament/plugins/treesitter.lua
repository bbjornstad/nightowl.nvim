local env = require("environment.ui")
local kenv = require("environment.keys")
local lz = require("funsak.lazy")
local key_view = kenv.view
local key_replace = kenv.replace
local key_treesj = kenv.tool.splitjoin
local function openURL(url)
  local opener
  if vim.fn.has("macunix") == 1 then
    opener = "open"
  elseif vim.fn.has("linux") == 1 then
    opener = "xdg-open"
  elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
    opener = "start"
  end
  local openCommand = string.format("%s '%s' >/dev/null 2>&1", opener, url)
  vim.fn.system(openCommand)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "RRethy/nvim-treesitter-endwise", optional = true },
      { "RRethy/nvim-treesitter-textsubjects", optional = true },
      { "nvim-treesitter/nvim-treesitter-textobjects", optional = true },
      { "nvim-treesitter/nvim-treesitter-context", optional = true },
      { "windwp/nvim-ts-autotag", optional = true },
      { "JoosepAlviste/nvim-ts-context-commentstring", optional = true },
      { "nvim-treesitter/nvim-treesitter-refactor", optional = true },
    },
    opts = function(_, opts)
      opts.ensure_installed = "all"
      opts.ignore_install =
        vim.list_extend({ "comment" }, opts.ignore_install or {})
      opts.auto_install = true
      opts.indent =
        vim.tbl_deep_extend("force", { enable = true }, opts.indent or {})
      opts.highlight =
        vim.tbl_deep_extend("force", { enable = true }, opts.highlight or {})
      opts.incremental_selection = vim.tbl_deep_extend("force", {
        enable = false,
      }, opts.incremental_selection or {})
      -- matchup = { enable = true },
      opts.query_linter =
        vim.tbl_deep_extend("force", { enable = true }, opts.query_linter or {})
      opts.refactor = vim.tbl_deep_extend(
        "force",
        lz.opts("nvim-treesitter-refactor"),
        opts.refactor or {}
      )
      opts.endwise = vim.tbl_deep_extend(
        "force",
        lz.opts("nvim-treesitter-endwise"),
        opts.endwise or {}
      )
      opts.textobjects = vim.tbl_deep_extend(
        "force",
        lz.opts("nvim-treesitter-textobjects"),
        opts.textobjects or {}
      )
      opts.textsubjects = vim.tbl_deep_extend(
        "force",
        lz.opts("nvim-treesitter-textsubjects"),
        opts.textsubjects or {}
      )
      opts.autotag = vim.tbl_deep_extend(
        "force",
        lz.opts("nvim-ts-autotag"),
        opts.autotag or {}
      )
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    build = ":TSUpdateSync",
    event = "VeryLazy",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)
    end,
    opts = { enable_autocmd = true },
  },
  {
    "RRethy/nvim-treesitter-endwise",
    ft = { "ruby", "lua", "vim", "bash", "elixir", "fish", "julia" },
    opts = { enable = true },
    config = function(_, opts)
      -- require("nvim-treesitter.configs").setup({ endwise = opts })
    end,
  },
  {
    "RRethy/nvim-treesitter-textsubjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function(_, opts)
      -- require("nvim-treesitter.configs").setup({ textsubjects = opts })
    end,
    opts = {
      enable = true,
      prev_selection = ",",
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-container-outer",
        ["i;"] = {
          "textsubjects-container-inner",
          desc = "Select inside containers (classes, functions, etc.)",
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function(_, opts)
      -- require("nvim-treesitter.configs").setup({ textobjects = opts })
    end,
    opts = {
      lsp_interop = {
        enable = true,
        border = env.borders.main,
      },
      move = {
        enable = true,
      },
      select = {
        enable = true,
      },
      swap = {
        enable = false,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    keys = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context()
        end,
        mode = "n",
        silent = true,
        desc = "ctx=> upwards to context",
      },
    },
    opts = {
      enable = true,
      mode = "cursor",
      zindex = 10,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    opts = {
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
    },
    config = function(_, opts)
      -- require("nvim-treesitter.configs").setup({ autotag = opts })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function(_, opts)
      -- require("nvim-treesitter.configs").setup({ refactor = opts })
    end,
    opts = {
      highlight_current_scope = {
        enable = false,
      },
      highlight_definitions = {
        enable = false,
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = key_replace.treesitter,
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = key_view.treesitter_nav.definition,
          goto_next_usage = key_view.treesitter_nav.next_usage,
          goto_previous_usage = key_view.treesitter_nav.previous_usage,
          list_definitions = key_view.treesitter_nav.list_definitions,
          list_definitions_toc = key_view.treesitter_nav.list_definitions_toc,
        },
      },
    },
  },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function(_, opts)
      require("wildfire").setup(opts)
    end,
    opts = {
      surrounds = {
        { "(", ")" },
        { "{", "}" },
        { "<", ">" },
        { "[", "]" },
      },
      keymaps = {
        init_selection = "<BS>",
        node_incremental = "<BS>",
        node_decremental = "<S-BS>",
      },
      filetype_exclude = env.ft_ignore_list,
    },
  },
  {
    "haringsrob/nvim_context_vt",
    event = "VeryLazy",
    config = true,
    opts = {
      enabled = true,
      prefix = " 󰡱 󰟵 ",
      disable_ft = env.ft_ignore_list,
      min_rows = 0,
      highlight = "NightowlContextHintsBright",
    },
    keys = {
      {
        key_view.context.toggle,
        "<CMD>NvimContextVtToggle<CR>",
        mode = "n",
        desc = "context=> inline toggle",
      },
      {
        key_view.context.debug,

        "<CMD>NvimContextVtDebug<CR>",
        mode = "n",
        desc = "context=> inline debug",
      },
    },
  },
  {
    "code-biscuits/nvim-biscuits",
    enabled = true,
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      cursor_line_only = false,
      default_config = {
        prefix_string = " 󱦆 ",
        max_length = 32,
        min_distance = 3,
        trim_by_words = false,
      },
      language_config = {
        markdown = {
          disabled = true,
        },
        org = {
          disabled = true,
        },
        norg = {
          disabled = true,
        },
        vimdoc = {
          disabled = true,
        },
      },
      toggle_keybind = key_view.context.biscuits,
      on_events = { "InsertLeave", "CursorHoldI" },
    },
    config = function(_, opts)
      require("nvim-biscuits").setup(opts)
    end,
  },
  {
    "jdrupal-dev/code-refactor.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>cR",
        "<cmd>CodeActions all<CR>",
        mode = "n",
      },
    },
    opts = {},
    config = function(_, opts)
      require("code-refactor").setup(opts)
    end,
  },
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer()
        end,
        mode = { "x", "o" },
        desc = "ts:obj| indent |=> outer",
      },
      {
        "aI",
        function()
          require("treesitter_indent_object.textobj").select_indent_outer(true)
        end,
        mode = { "x", "o" },
        desc = "ts:obj| indent |=> outer [line]",
      },
      {
        "ii",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner()
        end,
        mode = { "x", "o" },
        desc = "ts:obj| indent |=> inner",
      },
      {
        "iI",
        function()
          require("treesitter_indent_object.textobj").select_indent_inner(
            true,
            "V"
          )
        end,
        mode = { "x", "o" },
        desc = "ts:obj| indent |=> inner [line]",
      },
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    opts = {
      useDefaultKeymaps = true,
      disabledKeymaps = { "ii", "ai", "iI", "aI", "gw", "gW", "gc", "gC" },
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("various-textobjs").setup(opts)
    end,
    keys = {
      {
        "gx",
        function()
          require("various-textobjs").url()
          local found = vim.fn.mode():find("v")
          if not found then
            return
          end
          -- retrieve URL with the z-register as intermediary
          vim.cmd.normal({ "\"zy", bang = true })
          local url = vim.fn.getreg("z")
          openURL(url)
        end,
        mode = "n",
        desc = "ts:obj| gxnext |=> open link",
      },
    },
  },
  {
    "Wansmer/treesj",
    keys = {
      {
        key_treesj.toggle,
        function()
          require("treesj").toggle()
        end,
        mode = "n",
        desc = "treesj=> toggle fancy splitjoin",
      },
      {
        key_treesj.join,
        function()
          require("treesj").join()
        end,
        mode = "n",
        desc = "treesj=> join with splitjoin",
      },
      {
        key_treesj.split,
        function()
          require("treesj").split()
        end,
        mode = "n",
        desc = "treesj=> split with splitjoin",
      },
    },
    config = function(_, opts)
      require("treesj").setup(opts)
    end,
    opts = {
      -- Use default keymaps
      -- (<space>m - toggle, <space>j - join, <space>s - split)
      use_default_keymaps = false,

      -- Node with syntax error will not be formatted
      check_syntax_error = true,

      -- If line after join will be longer than max value,
      -- node will not be formatted
      max_join_length = 120,

      -- hold|start|end:
      -- hold - cursor follows the node/place on which it was called
      -- start - cursor jumps to the first symbol of the node being formatted
      -- end - cursor jumps to the last symbol of the node being formatted
      cursor_behavior = "hold",

      -- Notify about possible problems or not
      notify = true,

      -- Use `dot` for repeat action
      dot_repeat = true,
    },
  },
}
