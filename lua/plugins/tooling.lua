local env = require("environment.ui")
local kenv = require("environment.keys")
local mapx = vim.keymap.set
local key_tterm = kenv.stems.toggleterm
local key_cterm = kenv.stems.customterm
local key_treesj = kenv.stems.treesj
local key_code_shot = kenv.stems.code_shot

local utiliterm = require("environment.utiliterm")

local inp = require("uutils.input")

return {
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
      winbar = {
        enabled = false,
      },
    },
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
      -- custom terminal mappings go here.
      {
        key_cterm .. "b",
        utiliterm.btop,
        mode = "n",
        desc = "term.mon=> btop",
      },
      {
        key_cterm .. "t",
        utiliterm.broot,
        mode = "n",
        desc = "term.mon=> broot",
      },
      {
        key_cterm .. "s",
        utiliterm.sysz,
        mode = "n",
        desc = "term.mon=> sysz",
      },
      {
        key_cterm .. "w",
        utiliterm.weechat,
        mode = "n",
        desc = "term.mon=> weechat",
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
        pattern = { "term://*toggleterm#*" },
        callback = function(ev)
          set_terminal_keymaps(ev.buf)
        end,
        group = vim.api.nvim_create_augroup("terminal_open_keymappings", {}),
      })
    end,
  },
  {
    "folke/flash.nvim",
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
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true, -- highly recommended enable
      preview = {
        win_height = 16,
        win_vheight = 2,
        delay_syntax = 80,
        border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        show_title = false,
        should_preview_cb = function(bufnr, winid)
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
    "niuiic/code-shot.nvim",
    config = true,
    dependencies = {
      "niuiic/core.nvim",
    },
    opts = {
      ---@return string output file path
      output = function()
        local core = require("core")
        local buf_name = vim.api.nvim_buf_get_name(0)
        return core.file.name(buf_name) .. ".png"
      end,
      ---@return string[]
      -- select_area: {s_start: {row: number, col: number}, s_end: {row: number, col: number}} | nil
      options = function(select_area)
        if not select_area then
          return {}
        end
        return {
          "--line-offset",
          select_area.s_start.row,
        }
      end,
    },
    keys = {
      {
        key_code_shot,
        function()
          require("code-shot").shot()
        end,
        mode = { "n", "v" },
        desc = "code=> screen shot",
      },
    },
  },
  {
    "cshuaimin/ssr.nvim",
    opts = {
      border = env.borders.main,
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
    config = function(_, opts)
      require("ssr").setup(opts)
    end,
    keys = {
      {
        "<leader>sp",
        function()
          require("ssr").open()
        end,
        mode = "n",
        desc = "search=> structural search replace",
      },
    },
  },
  {
    "rareitems/printer.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      require("printer").setup(opts)
    end,
    opts = {
      keymap = "gpp",
      behavior = "insert_below",
    },
  },
  {
    "AckslD/muren.nvim",
    config = function(_, opts)
      require("muren").setup(opts)
    end,
    cmd = {
      "MurenToggle",
      "MurenOpen",
      "MurenClose",
      "MurenFresh",
      "MurenUnique",
    },
    opts = {
      cwd = true,
    },
  },
}
