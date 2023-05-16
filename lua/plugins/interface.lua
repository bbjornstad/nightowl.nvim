local env = require("environment.ui")
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = { border = env.borders.main },
})

local stems = require("environment.keys").stems
local mapn = require("environment.keys").mapn
local key_notify = stems.notify
local key_vista = stems.vista
local key_lens = stems.lens

return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
      },
      views = {
        cmdline_popup = {
          position = { row = 16, col = "50%" },
          size = { width = vim.opt.textwidth:get(), height = "auto" },
          border = { style = env.borders.main, padding = { 1, 2 } },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              NormalFloat = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        popupmenu = {
          relative = "editor",
          position = { row = 20, col = "50%" },
          size = { width = 80, height = "auto" },
          border = { style = env.borders.main, padding = { 1, 2 } },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              NormalFloat = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        notify = {
          relative = "editor",
          border = { style = env.borders.main, padding = { 1, 2 } },
        },
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "Neogen: Language alpha not supported",
            kind = "",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = { input = { enabled = true, border = env.borders.main } },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },
  { "stevearc/oil.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "beauwilliams/focus.nvim",
    opts = {
      winhighlight = false,
      hybridnumber = true,
      absolutenumber_unfocussed = true,
      treewidth = 14,
    },
    event = { "VimEnter", "WinEnter" },
  },
  {
    "b0o/incline.nvim",
    config = function(_, opts)
      require("incline").setup(opts)
    end,
    event = { "BufReadPre" },
  },
  {
    "b0o/incline.nvim",
    opts = {
      render = function(props)
        local filename =
          vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local icon, color =
          require("nvim-web-devicons").get_icon_color(filename)
        return { { icon, guifg = color }, { " " }, { filename } }
      end,
    },
  },
  {
    "folke/which-key.nvim",
    opts = { window = { border = env.borders.main } },
    -- function(_, opts)
    --  opts.window = opts.window or {}
    --  table.insert(opts.window, { border = env.borders.main })
    -- end,
  },
  -- { "b0o/mapx.nvim", config = true, dependencies = { "folke/which-key.nvim" } },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "b0o/incline.nvim" },
    opts = {
      tabline = {
        lualine_a = { "buffers" },
        lualine_x = {
          {
            function()
              return require("nvim-navic").get_location()
            end,
            cond = function()
              return require("nvim-navic").is_available()
            end,
          },
        },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          { "filename >>" },
          {
            "navic",
            color_correction = "dynamic",
            navic_opts = env.navic.opts,
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    event = "LspAttach",
    -- opts = {
    --  hints = {
    --    parameter = { show = true, highlight = "Comment" },
    --    type = { show = true, highlight = "Comment" },
    --  },
    -- },
    config = function(_, opts)
      require("lsp-inlayhints").setup(opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, args.buf, false)
        end,
      })
    end,
  },
  { "junegunn/fzf", build = "make" },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    event = { "WinEnter", "VimEnter" },
  },
  {
    "rcarriga/nvim-notify",
    opts = { top_down = false, render = "compact" },
    init = function()
      mapn(
        key_notify .. "n",
        require("notify").history,
        { desc = "noit:>> notification history" }
      )
      mapn(
        key_notify .. "t",
        require("telescope").extensions.notify.notify,
        { desc = "noit:>> telescope search notification history" }
      )
    end,
  },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
  { "nvim-lua/lsp-status.nvim" },
  {
    "VidocqH/lsp-lens.nvim",
    opts = {
      include_declaration = true,
      sections = {
        definition = true,
        references = true,
        implementation = true,
      },
      ignore_filetype = { "prisma" },
    },
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    init = function()
      mapn(
        key_lens .. "t",
        "<CMD>LspLensToggle<CR>",
        { desc = "lens:>> toggle" }
      )
      mapn(key_lens .. "o", "<CMD>LspLensOn<CR>", { desc = "lens:>> on" })
      mapn(key_lens .. "f", "<CMD>LspLensOff<CR>", { desc = "lens:>> off" })
      mapn("<leader>uE", "<CMD>LspLensToggle<CR>", { desc = "lens:>> toggle" })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      vim.opt.list = true
      vim.opt.listchars:append("space:⋅")
      vim.opt.listchars:append("eol:↴")
    end,
    opts = {
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = true,
    },
  },
  { "karb94/neoscroll.nvim", event = "BufEnter" },
  {
    "yamatsum/nvim-cursorline",
    opts = {
      cursorline = { enable = true, timeout = 1000, number = false },
      cursorword = {
        enable = true,
        min_length = 3,
        hl = { underline = true },
      },
    },
  },
  { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "ray-x/lsp_signature.nvim", dependencies = { "neovim/nvim-lspconfig" } },
  {
    "liuchengxu/vista.vim",
    cmd = "Vista",
    init = function()
      mapn(
        key_vista .. "s",
        "<CMD>Vista show<CR>",
        { desc = "show vista tags" }
      )
      mapn(
        key_vista .. "f",
        "<CMD>Vista finder<CR>",
        { desc = "fzf over vista tags" }
      )
      mapn(
        key_vista .. "V",
        "<CMD>Vista finder<CR>",
        { desc = "fzf over vista tags" }
      )
    end,
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    event = { "BufEnter", "BufWinEnter" },
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("lazyvim.config").icons.kinds,
      }
    end,
  },
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = { border = env.borders.main },
  },
}
