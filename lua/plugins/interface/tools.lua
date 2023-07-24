local env = require("environment.ui")
local stems = require("environment.keys").stems
local mapx = vim.keymap.set
local key_tterm = stems.tterm

-- these are the core interface items. These are the base upon which the other
-- interface items are built. At the bottom of this file we merge all of the
-- loaded components together.
local iface_core = {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = {
      open_mapping = "<C-;>",
      float_opts = {
        border = env.borders.main,
        winblend = 20,
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
    init = function()
      vim.g.hidden = true
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        mapx("t", "<esc>", [[<C-\><C-n>]], opts)
        mapx("t", "jk", [[<C-\><C-n>]], opts)
        mapx("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        mapx("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        mapx("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        mapx("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        mapx("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      mapx({ "n", "t" }, key_tterm .. "v", function()
        require("toggleterm").setup({ direction = "vertical" })
      end, { desc = "toggle terminals vertically" })
      mapx({ "n", "t" }, key_tterm .. "h", function()
        require("toggleterm").setup({ direction = "horizontal" })
      end, { desc = "toggle terminals horizontally" })
      mapx({ "n", "t" }, key_tterm .. "f", function()
        require("toggleterm").setup({ direction = "float" })
      end, { desc = "toggle floating terminals" })
      mapx({ "n", "t" }, key_tterm .. "b", function()
        require("toggleterm").setup({ direction = "tabbed" })
      end, { desc = "toggle terminals vertically" })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "toggleterm" },
        group = vim.api.nvim_create_augroup("toggleterm_quit_on_q", {}),
        callback = function()
          vim.keymap.set(
            "n",
            "q",
            "<CMD>quit<CR>",
            { buffer = true, desc = "quit", remap = false, nowait = true }
          )
        end,
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
    "folke/which-key.nvim",
    opts = {
      plugins = {
        marks = false,
        registers = true,
      },
      window = {
        border = env.borders.main,
        winblend = 25,
        zindex = 1000,
      },
      triggers_nowait = {
        "g`",
        "g'",
        -- registers
        '"',
        "<c-r>",
        -- spelling
        "z=",
      },
      documentation = {
        view = "hover",
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      },
    },
  },
  {
    "jghauser/mkdir.nvim",
    event = "VeryLazy",
  },
  {
    "nvimdev/template.nvim",
    cmd = { "Template", "TemProject" },
    config = true,
    opts = {
      temp_dir = "~/.config/nvim/templates",
    },
  },
  {
    "Wansmer/treesj",
    keys = {
      {
        "<space>m",
        function()
          require("treesj").toggle()
        end,
        mode = "n",
        desc = "treesj=> toggle fancy splitjoin",
      },
      {
        "<space>j",
        function()
          require("treesj").join()
        end,
        mode = "n",
        desc = "treesj=> join with splitjoin",
      },
      {
        "<space>p",
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
    "max397574/better-escape.nvim",
    event = "VeryLazy",
    config = true,
    opts = {
      mapping = { "jj", "jk" },
      timeout = vim.o.timeoutlen,
      clear_empty_lines = true,
      keys = "<Esc>",
    },
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
-- {
--   iface_core,
--   -- require("plugins.interface.windows"),
--   -- require("plugins.interface.location"),
--   -- require("plugins.interface.barowl"),
-- }
