local env = require("environment.ui")
local stems = require("environment.keys").stems
local mapx = vim.keymap.set
local key_tterm = stems.tterm
local key_based = stems.based
local key_block = stems.block
local key_easyread = stems.easyread
local key_treesj = stems.treesj

-- these are the core interface items. These are the base upon which the other
-- interface items are built. At the bottom of this file we merge all of the
-- loaded components together.
local iface_core = {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = {
      open_mapping = "<F1>",
      float_opts = {
        border = env.borders.main,
        winblend = 10,
      },
      insert_mappings = false,
      terminal_mappings = true,
      autochdir = true,
      direction = "float",
      size = function(term)
        if term.direction == "horizontal" then
          return 0.25 * vim.api.nvim_win_get_height(0)
        elseif term.direction == "vertical" then
          return 0.25 * vim.api.nvim_win_get_width(0)
        elseif term.direction == "float" then
          return 85
        end
      end,
      shading_factor = 2,
    },
    event = { "VeryLazy" },
    keys = {
      {
        key_tterm .. "v",
        function()
          require("toggleterm").setup({ direction = "vertical" })
        end,
        mode = { "n", "t" },
        desc = "term=> toggle vertical layout",
      },
      {
        key_tterm .. "h",
        function()
          require("toggleterm").setup({ direction = "horizontal" })
        end,
        mode = { "n", "t" },
        desc = "term=> toggle horizontal layout",
      },
      {
        key_tterm .. "f",
        function()
          require("toggleterm").setup({ direction = "float" })
        end,
        mode = { "n", "t" },
        desc = "term=> toggle float layout",
      },
      {
        key_tterm .. "b",
        function()
          require("toggleterm").setup({ direction = "tabbed" })
        end,
        mode = { "n", "t" },
        desc = "term=> toggle tabbed layout",
      },
    },
    init = function()
      vim.g.hidden = true
      local function set_terminal_keymaps(bufnr)
        local opts = { buffer = bufnr or 0 }
        mapx(
          "t",
          "<esc>",
          [[<C-\><C-n>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> escape",
          }, opts)
        )
        mapx(
          "t",
          "jk",
          [[<C-\><C-n>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> escape",
          }, opts)
        )
        mapx(
          "t",
          "<C-h>",
          [[<Cmd>wincmd h<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> go to left window",
          }, opts)
        )
        mapx(
          "t",
          "<C-j>",
          [[<Cmd>wincmd j<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> go to below window",
          }, opts)
        )
        mapx(
          "t",
          "<C-k>",
          [[<Cmd>wincmd k<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> go to above window",
          }, opts)
        )
        mapx(
          "t",
          "<C-l>",
          [[<Cmd>wincmd l<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> go to right window",
          }, opts)
        )
        mapx(
          "t",
          "<C-w>",
          [[<C-\><C-n><C-w>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term=> window management",
          }, opts)
        )
        mapx(
          "t",
          "q",
          "<CMD>quit<CR>",
          vim.tbl_deep_extend("force", {
            remap = false,
            nowait = true,
            desc = "term=> close terminal",
          }, opts)
        )
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = { "term://*" },
        callback = function(ev)
          set_terminal_keymaps(ev.buf)
        end,
        group = vim.api.nvim_create_augroup("terminal_open_keymappings", {}),
      })
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      label = {
        rainbow = {
          enabled = true,
        },
        style = "overlay",
      },
      modes = {
        char = {
          keys = { "f", "F", "t", "T", "," },
        },
      },
    },
  },
  {
    "jghauser/mkdir.nvim",
    event = "VeryLazy",
  },
  {
    "Wansmer/treesj",
    keys = {
      {
        key_treesj .. "j",
        function()
          require("treesj").toggle()
        end,
        mode = "n",
        desc = "treesj=> toggle fancy splitjoin",
      },
      {
        key_treesj .. "J",
        function()
          require("treesj").join()
        end,
        mode = "n",
        desc = "treesj=> join with splitjoin",
      },
      {
        key_treesj .. "p",
        function()
          require("treesj").split()
        end,
        mode = "n",
        desc = "treesj=> split with splitjoin",
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
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
  {
    "arjunmahishi/flow.nvim",
    cmd = {
      "FlowRunSelected",
      "FlowRunFile",
      "FlowSetCustomCmd",
      "FlowRunCustomCmd",
      "FlowLauncher",
      "FlowRunLastCmd",
      "FlowLastOutput",
    },
    config = true,

    opts = function(_, opts)
      opts.output = vim.tbl_extend("force", {
        buffer = true,
        split_cmd = "20split",
      }, opts.output or {})

      -- add/override the default command used for a perticular filetype
      -- the "%s" you see in the below example is interpolated by the contents of
      -- the file you are trying to run
      -- Format { <filetype> = <command> }
      opts.filetype_cmd_map = vim.tbl_extend("force", {
        python = "python3 <<-EOF\n%s\nEOF",
      }, opts.filetype_cmd_map)

      local function config_sql_wrapper(path)
        return vim.require("flow.util").read_sql_config(path)
      end

      -- optional DB configuration for running .sql files/snippets (experimental)
      opts.sql_configs = opts.sql_configs
        or config_sql_wrapper(
          vim.fn.stdpath("data") .. "flow/flowdb/.db_config.json"
        )
    end,
  },
  {
    "TheBlob42/houdini.nvim",
    config = true,
    opts = {
      mappings = { "jj", "jk" },
      timeout = vim.o.timeoutlen,
      check_modified = true,
    },
    event = "VeryLazy",
  },
  -- {
  --   "max397574/better-escape.nvim",
  --   event = "VeryLazy",
  --   config = true,
  --   opts = {
  --     mapping = { "jj" },
  --     timeout = vim.o.timeoutlen,
  --     clear_empty_lines = true,
  --     keys = "<Esc>",
  --   },
  -- },
  {
    "axieax/urlview.nvim",
    cmd = "UrlView",
    config = true,
    opts = {
      default_picker = "native",
      default_title = "  󱅸",
    },
    keys = {
      {
        "gLg",
        "<CMD>UrlView<CR>",
        mode = "n",
        desc = "url=> view global links",
      },
      {
        "gLl",
        "<CMD>UrlView buffer<CR>",
        mode = "n",
        desc = "url=> view links in buffer",
      },
      {
        "gLp",
        "<CMD>UrlView lazy<CR>",
        mode = "n",
        desc = "url=> view lazy links",
      },
    },
  },
  {
    "tzachar/local-highlight.nvim",
    opts = {
      disable_file_types = { "markdown" },
    },
    config = true,
    event = "VeryLazy",
  },
  {
    "tzachar/highlight-undo.nvim",
    config = true,
    enabled = false,
    opts = {
      keymaps = {
        { "n", "u", "undo", {} },
        { "n", "<C-r>", "redo", {} },
      },
    },
    event = "VeryLazy",
  },
  {
    "trmckay/based.nvim",
    opts = {
      highlight = "BasedHighlight",
    },
    keys = {
      {
        "<leader>Bc",
        function()
          vim.ui.input({ prompt = "base: " }, function(input)
            require("based").convert(input)
          end)
          require("based").convert()
        end,
        mode = { "n", "v" },
        desc = "base=> convert base",
      },
      {
        "<leader>Bh",
        function()
          require("based").convert("hex")
        end,
        mode = { "n", "v" },
        desc = "base=> convert to hex",
      },
      {
        "<leader>Bd",
        function()
          require("based").convert("dec")
        end,
        mode = { "n", "v" },
        desc = "base=> convert to decimal",
      },
    },
  },
  {
    "HampusHauffman/bionic.nvim",
    cmd = { "Bionic", "BionicOn", "BionicOff" },
    keys = {
      {
        key_easyread,
        "<CMD>Bionic<CR>",
        mode = { "n" },
        desc = "bionic=> toggle flow-state bionic reading",
      },
    },
  },
  {
    "HampusHauffman/block.nvim",
    opts = {
      percent = 1.1,
      depth = 8,
      automatic = true,
    },
    config = true,
    cmd = { "Block", "BlockOn", "BlockOff" },
    keys = {
      {
        key_block,
        "<CMD>Block<CR>",
        mode = "n",
        desc = "block=> toggle block highlighting",
      },
    },
  },
  {
    "realprogrammersusevim/readability.nvim",
    cmd = { "ReadabilitySmog", "ReadabilityFlesch" },
  },
  {
    "MisanthropicBit/decipher.nvim",
    opts = {
      float = {
        padding = 2,
        border = env.borders.main,
        title = true,
        title_pos = "right",
        autoclose = true,
        enter = false,
        options = { winblend = 25 },
      },
    },
    config = true,
    keys = {
      {
        "<localleader>ne",
        function()
          vim.ui.input({
            prompt = "value to encode:",
          }, function(input)
            require("decipher").encode("base64", input)
          end)
        end,
        mode = "n",
        desc = "ncode=> encode text (base64)",
      },
      {
        "<localleader>de",
        function()
          vim.ui.input({
            prompt = "value to decode:",
          }, function(input)
            require("decipher").decode("base64", input)
          end)
        end,
        mode = "n",
        desc = "dcode=> decode text (base64)",
      },
    },
  },
  {
    "jbyuki/quickmath.nvim",
    cmd = "Quickmath",
    opts = {},
    config = true,
    keys = {
      {
        "<leader>C",
        "<CMD>Quickmath<CR>",
        mode = "n",
        desc = "calc=> open quickmath",
      },
    },
  },
  {
    "t-troebst/perfanno.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.formats = vim.tbl_deep_extend("force", {
        { percent = true, format = "%.2f%%", minimum = 0.5 },
        { percent = false, format = "%d", minimum = 1 },
      }, opts.formats or {})
      opts.annotate_after_load = opts.annotate_after_load or true
      opts.annotate_on_open = opts.annotate_on_open or true
      opts.telescope = vim.tbl_deep_extend("force", {
        -- Enable if possible, otherwise the plugin will fall back to vim.ui.select
        enabled = pcall(require, "telescope"),
        -- Annotate inside of the preview window
        annotate = true,
      }, opts.telescope or {})

      -- Node type patterns used to find the function that surrounds the cursor
      opts.ts_function_patterns = vim.tbl_deep_extend("force", {
        -- These should work for most languages (at least those used with perf)
        default = {
          "function",
          "method",
        },
        -- Otherwise you can add patterns for specific languages like:
        -- weirdlang = {
        --     "weirdfunc",
        -- }
      }, opts.ts_function_patterns or {})
    end,
    config = true,
    event = {},
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true, -- highly recommended enable
      preview = {
        win_height = 16,
        win_vheight = 16,
        delay_syntax = 80,
        border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        show_title = true,
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match("^fugitive://") then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end,
      },
      -- make `drop` and `tab drop` to become preferred
      func_map = {
        drop = "o",
        openc = "O",
        split = "<C-s>",
        tabdrop = "<C-t>",
        -- set to empty string to disable
        tabc = "",
        ptogglemode = "z,",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
    config = true,
  },
}

-- explicitly put all of the component parts to the interface submodule into the
-- final set, this could be automated with some not too difficult algorithms.
-- But, because this is a rather important core component of the entire neovim
-- configuration, I think it makes more sense to be verbose here...personal
-- preferences really.
--
-- as a side note, this also allows to control the order in which the submodules
-- are stacked up which might be kind of nice depending on how you want to build
-- something like this. But this is only relevant for merging the table
-- specifications, it doesn't actually affect the order of the loading of
-- plugins, just how the configurations get stacked beforehand.
return iface_core
