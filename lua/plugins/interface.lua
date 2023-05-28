local env = require("environment.ui")
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  -- float = { border = env.borders.main },
})

local stems = require("environment.keys").stems
local mapn = require("environment.keys").map("n")
local mapx = vim.keymap.set
local key_notify = stems.notify
local key_vista = stems.vista
local key_lens = stems.lens
local key_oil = stems.oil
local key_git = stems.git

--────────────────────────────────────────────────────────────-----------------
-- This is to change filename color in the window bar based on the git status.
-- Modified is now a nice purple color (defined directly from the kanagawa theme)
-- New will be green, as would be typical.
--
-- TODO: Change the below so that it uses git status via gitsigns instead of the
-- simple file status locally. Or, mayhaps, we can put in the local status as a
-- fallback in cases where the git status isn't available.
-- ----
local custom_fname = require("lualine.components.filename"):extend()
local highlight = require("lualine.highlight")
local kanacolor = require("kanagawa.colors").setup({ theme = "wave" }).palette
local default_status_colors =
  { saved = kanacolor.lotusBlue3, modified = kanacolor.lotusGreen }

function custom_fname:init(options)
  custom_fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group(
      { fg = default_status_colors.saved },
      "filename_status_saved",
      self.options
    ),
    modified = highlight.create_component_highlight_group(
      { fg = default_status_colors.modified },
      "filename_status_modified",
      self.options
    ),
  }
  if self.options.color == nil then
    self.options.color = ""
  end
end

function custom_fname:update_status()
  local data = custom_fname.super.update_status(self)
  data = highlight.component_format_highlight(
    vim.bo.modified and self.status_colors.modified or self.status_colors.saved
  ) .. data
  return data
end

return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    module = false,
  },
  {
    "folke/noice.nvim",
    opts = {
      -- debug = true,
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          enabled = not env.enable_lsp_signature,
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,
        -- lsp_doc_border = true,
      },
      views = {
        cmdline_popup = {
          position = { row = 16, col = "50%" },
          size = {
            width = math.max(80, vim.opt.textwidth:get()),
            height = "auto",
          },
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
        hover = {
          view = "popup",
          size = {
            max_height = 30,
            max_width = 120,
          },
          border = {
            style = env.borders.main,
            padding = { 1, 2 },
          },
        },
        popup = {
          border = { style = env.borders.main },
        },
        notify = {
          relative = "editor",
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
        {
          filter = {
            event = "msg_show",
            find = "nvim-biscuits",
            kind = "",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
      delete_to_trash = true,
      float = {
        padding = 2,
        border = env.borders.main,
      },
      preview = {
        border = env.borders.main,
        win_options = {
          winblend = 10,
        },
      },
      progress = {
        border = env.borders.main,
        minimized_border = env.borders.main,
        win_options = {
          winblend = 10,
        },
      },
      keymaps = {
        ["."] = "actions.cd",
        ["`"] = false,
        ["<C-t>"] = false,
      },
    },
    --keys = {
    --  {
    --    key_oil .. "o",
    --    require("oil").open_float,
    --    desc = "oil=> open oil (float)",
    --  },
    --  {
    --    key_oil .. "q",
    --    require("oil").close,
    --    desc = "oil=> close oil",
    --  },
    --},
  },
  {
    "beauwilliams/focus.nvim",
    opts = {
      winhighlight = false,
      hybridnumber = true,
      absolutenumber_unfocussed = true,
      treewidth = 14,
    },
    event = "VeryLazy",
  },
  {
    "b0o/incline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      render = function(props)
        local navic = function(props)
          return require("nvim-navic").get_location({}, props.buf)
        end
        if require("nvim-navic").is_available(props.buf) then
          return { navic(props) }
        else
          return {}
        end
      end,
      window = {
        margin = { vertical = 0, horizontal = 1 },
        padding = 2,
        placement = { horizontal = "right", vertical = "top" },
        width = "fit",
        options = { winblend = 20, signcolumn = "no", wrap = false },
        winhighlight = {
          InclineNormal = {
            guibg = require("kanagawa.colors").setup({ theme = "wave" }).palette.sumiInk2,
          },
          InclineNormalNC = {
            guibg = require("kanagawa.colors").setup({ theme = "wave" }).palette.sumiInk1,
          },
        },
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {
      debug = true,
      bind = true,
      verbose = true,
      noice = true,
      always_trigger = false,
      transparency = 10,
      shadow_blend = 36,
      shadow_guibg = require("kanagawa.colors").setup({ theme = "wave" }).theme.ui.bg_dim,
    },
    enabled = env.enable_lsp_signature,
  },
  {
    "TimUntersberger/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "VeryLazy" },
    cmd = { "Neogit" },
    opts = {
      integrations = { diffview = true },
    },
    init = function()
      mapx(
        { "n", "v" },
        key_git .. "n",
        "<CMD>Neogit<CR>",
        { desc = "git=> neogit" }
      )
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "b0o/incline.nvim",
      "nvim-lua/lsp-status.nvim",
    },
    opts = {
      options = {
        icons_enabled = true,
        globalstatus = true,
        omponent_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = require("lazyvim.config").icons.diagnostics.Error,
              warn = require("lazyvim.config").icons.diagnostics.Warn,
              info = require("lazyvim.config").icons.diagnostics.Info,
              hint = require("lazyvim.config").icons.diagnostics.Hint,
            },
          },
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 2, right = 1 },
          },
          {
            "filename",
            path = 1,
            symbols = {
              modified = "",
              readonly = "󱪛",
              unnamed = "",
            },
          },
        },
      },

      tabline = {
        lualine_a = { "buffers" },
        -- lualine_x = {
        --  {
        --    function()
        --      return require("nvim-navic").get_location()
        --    end,
        --    enabled = function()
        --      return require("nvim-navic").is_available()
        --    end,
        --  },
        -- },
        lualine_x = {
          --{
          --  vim.b.lsp_current_function,
          --},
        },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filetype",
            icon_only = false,
            separator = "  ",
            padding = { left = 1, right = 1 },
          },
          {
            "diagnostics",
            symbols = {
              error = require("lazyvim.config").icons.diagnostics.Error,
              warn = require("lazyvim.config").icons.diagnostics.Warn,
              info = require("lazyvim.config").icons.diagnostics.Info,
              hint = require("lazyvim.config").icons.diagnostics.Hint,
            },
          },
          --
        },
        lualine_x = {
          -- { require("lsp-status").status() },
          {
            custom_fname,
            symbols = {
              modified = "",
              readonly = "󱪛",
              unnamed = "",
            },
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        -- lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
  {
    "code-biscuits/nvim-biscuits",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      cursor_line_only = true,
    },
    event = { "LspAttach" },
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    event = "LspAttach",
    opts = function(_, opts)
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
  {
    "junegunn/fzf",
    dependencies = { "junegunn/fzf.vim" },
    build = "make",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fzf" },
        group = vim.api.nvim_create_augroup("fzf quit on q", {}),
        callback = function()
          vim.keymap.set(
            "n",
            "q",
            "<CMD>quit<CR>",
            { desc = "quit", remap = false }
          )
        end,
      })
    end,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    event = { "VeryLazy" },
  },
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.top_down = true
      opts.render = "compact"
      opts.on_open = function(win)
        vim.api.nvim_win_set_config(win, { border = env.borders.main })
      end
    end,
    init = function()
      mapn(
        key_notify .. "n",
        require("notify").history,
        { desc = "noit=> notification history" }
      )
      mapn(
        key_notify .. "t",
        require("telescope").extensions.notify.notify,
        { desc = "noit=> telescope search notification history" }
      )
    end,
  },
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },
  --{
  --  "nvim-lua/lsp-status.nvim",
  --  opts = {},
  --  config = function() end,
  --},
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
        { desc = "lens=> toggle" }
      )
      mapn(key_lens .. "o", "<CMD>LspLensOn<CR>", { desc = "lens=> on" })
      mapn(key_lens .. "f", "<CMD>LspLensOff<CR>", { desc = "lens=> off" })
      mapn("<leader>uE", "<CMD>LspLensToggle<CR>", { desc = "lens=> toggle" })
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
  { "karb94/neoscroll.nvim", event = "VeryLazy" },
  {
    "yamatsum/nvim-cursorline",
    event = "VeryLazy",
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
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    keys = {
      {
        key_vista .. "s",
        "<CMD>SymbolsOutline<CR>",
        { desc = "toggle symbols outline" },
      },
      {
        key_vista .. "q",
        "<CMD>SymbolsOutlineClose<CR>",
        { desc = "close symbols outline (force)" },
      },
      {
        key_vista .. "o",
        "<CMD>SymbolsOutlineOpen<CR>",
        { desc = "open symbols outline (force)" },
      },
    },
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "LspAttach",
    opts = {
      separator = " 󰁕 ",
      highlight = false,
      depth_limit = 7,
      icons = require("lazyvim.config").icons.kinds,
    },
  },
  {
    "johann2357/nvim-smartbufs",
    opts = {},
    event = "VeryLazy",
    config = function() end,
    init = function()
      mapx(
        { "n", "v" },
        "<leader>b[",
        "<CMD>lua require('nvim-smartbufs').goto_prev_buffer()<CR>",
        { desc = "buf=> previous buffer" }
      )

      mapx(
        { "n", "v" },
        "<leader>b]",
        "<CMD>lua require('nvim-smartbufs').goto_next_buffer()<CR>",
        { desc = "buf=> next buffer" }
      )
      mapx(
        { "n", "v", "i" },
        "<C-S-Left>",
        "<CMD>lua require('nvim-smartbufs').goto_prev_buffer()<CR>",
        { desc = "buf=> previous buffer" }
      )
      mapx(
        { "n", "v", "i" },
        "<C-S-Right>",
        "<CMD>lua require('nvim-smartbufs').goto_next_buffer()<CR>",
        { desc = "buf=> next buffer" }
      )
      for i = 1, 9, 1 do
        local keynum = i
        mapn(
          "<leader>" .. keynum,
          string.format(
            "<CMD>lua require('nvim-smartbufs').goto_buffer(%d)<CR>",
            keynum
          ),
          { desc = string.format("buf=> goto buffer %d", keynum) }
        )
        mapn(
          "<leader>q" .. keynum,
          string.format(
            "<CMD>lua require('nvim-smartbufs').close_buffer(%d)<CR>",
            keynum
          ),
          { desc = string.format("buf=> leave buffer %d", keynum) }
        )
      end
      mapx(
        { "n", "v" },
        "<leader>bq",
        "<CMD>lua require('nvim-smartbufs').close_current_buffer()<CR>",
        { desc = "buf=> intelligently close current buffer" }
      )
      mapx(
        { "n", "v" },
        "<leader>bq",
        "<CMD>lua require('nvim-smartbufs').close_current_buffer()<CR>",
        { desc = "buf=> intelligently close current buffer" }
      )
    end,
  },
}
