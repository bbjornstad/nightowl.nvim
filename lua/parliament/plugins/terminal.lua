local env = require("environment.ui")
local kenv = require("environment.keys")
local key_term = kenv.term
local mapx = vim.keymap.set
local utiliterm = require("environment.utiliterm")

return {
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
    opts = {
      open_mapping = "<F1>",
      float_opts = {
        border = env.borders.main,
        winblend = 8,
      },
      insert_mappings = true,
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
      shading_factor = 5,
      winbar = {
        enabled = true,
        name_formatter = function(term)
          return ("--  : %s"):format(term.name)
        end,
      },
    },
    keys = {
      {
        key_term.layout.vertical,
        function()
          require("toggleterm").setup({ direction = "vertical" })
        end,
        mode = { "n", "t" },
        desc = "term:| layout |=> vertical",
      },
      {
        key_term.layout.horizontal,
        function()
          require("toggleterm").setup({ direction = "horizontal" })
        end,
        mode = { "n", "t" },
        desc = "term:| layout |=> horizontal",
      },
      {
        key_term.layout.float,
        function()
          require("toggleterm").setup({ direction = "float" })
        end,
        mode = { "n", "t" },
        desc = "term:| layout |=> float",
      },
      {
        key_term.layout.tabbed,
        function()
          require("toggleterm").setup({ direction = "tabbed" })
        end,
        mode = { "n", "t" },
        desc = "term:| layout |=> tabbed",
      },
      -- custom terminal mappings go here.
      {
        key_term.utiliterm.btop,
        utiliterm.btop(),
        mode = "n",
        desc = "term:| mon |=> btop",
      },
      {
        key_term.utiliterm.sysz,
        utiliterm.sysz(),
        mode = "n",
        desc = "term:| mon |=> sysz",
      },
      {
        key_term.utiliterm.weechat,
        utiliterm.weechat(),
        mode = "n",
        desc = "term:| mon |=> weechat",
      },
      {
        key_term.utiliterm.broot,
        utiliterm.broot(),
        mode = "n",
        desc = "term:| fm |=> broot",
      },
      {
        key_term.utiliterm.gitui,
        utiliterm.gitui(),
        mode = "n",
        desc = "term:| git |=> gitui",
      },
    },
    init = function()
      vim.g.hidden = true
      local function set_terminal_keymaps(bufnr)
        local opts = { buffer = bufnr or 0 }
        mapx(
          "t",
          "<S-Esc>",
          [[<C-\><C-n>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term:| sys |=> escape",
          }, opts)
        )
        mapx(
          "t",
          "<C-S-h>",
          [[<Cmd>wincmd h<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term:| go |=> left window",
          }, opts)
        )
        mapx(
          "t",
          "<C-S-j>",
          [[<Cmd>wincmd j<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term:| go |=> below",
          }, opts)
        )
        mapx(
          "t",
          "<C-S-k>",
          [[<Cmd>wincmd k<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term:| go |=> above",
          }, opts)
        )
        mapx(
          "t",
          "<C-S-l>",
          [[<Cmd>wincmd l<CR>]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term:| go |=> right",
          }, opts)
        )
        mapx(
          "t",
          "<Leader>w",
          [[<C-\><C-n> w]],
          vim.tbl_deep_extend("force", {
            nowait = true,
            desc = "term:| sys |=> window",
          }, opts)
        )
        mapx(
          "t",
          [[<C-\><C-q>]],
          "<CMD>quit<CR>",
          vim.tbl_deep_extend("force", {
            remap = false,
            nowait = true,
            desc = "term:| sys |=> close",
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
      local fixer =
        require("funsak.autocmd").buffixcmdr("ToggletermBufFix", true)
      fixer({ "TermOpen" }, { pattern = "term://*" })
    end,
  },
}
