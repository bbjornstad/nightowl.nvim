local env = require("environment.ui")
local stems = require("environment.keys").stems
local mapn = require("environment.keys").map("n")
local mapx = vim.keymap.set
local key_notify = stems.notify
local key_vista = stems.vista
local key_lens = stems.lens
local key_git = stems.git
local key_oil = stems.oil
local key_tterm = stems.tterm

--------------------------------------------------------------------------------
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

local function memory_use()
  local use = (1 - (vim.loop.get_free_memory() / vim.loop.get_total_memory()))
    * 100
  return ("󱈭 Used: %.2f"):format(use) .. "%"
end

local function pomodoro()
  local pom = require("pomdoro")
  local possible_status = pom.statusline()
  if possible_status == nil then
    return "󱦠..."
  end
  return string.format("󰔟 [%s]", possible_status)
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

return {
  {
    "williamboman/mason.nvim",
    opts = { ui = { border = env.borders.main_accent } },
  },
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
          enabled = true,
        },
      },
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,
      },
      views = {
        popup = {
          border = {
            style = env.borders.main,
          },
        },
        cmdline_popup = {
          position = { row = 16, col = "50%" },
          size = {
            width = math.max(80, vim.opt.textwidth:get()),
            height = "auto",
          },
          -- put it on top of everything else that could exist below (we picked
          -- 1200 because it was larger than the largest present zindex
          -- definition for any other component)
          zindex = 1200,
          border = { style = env.borders.main, padding = { 1, 2 } },
          win_options = {
            winhighlight = {
              -- Normal = "Normal",
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        popupmenu = {
          relative = "editor",
          position = { row = 20, col = "50%" },
          size = { width = 80, height = "auto" },
          -- once again, put it on top of everything else that could exist below.
          -- 1200 rationale still holds here too.
          zindex = 1200,
          border = { style = env.borders.main, padding = { 1, 2 } },
          win_options = {
            winhighlight = {
              -- Normal = "Normal",
              Normal = "NormalFloat",
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
        confirm = {
          border = {
            style = env.borders.main,
            padding = { 1, 2 },
            text = {},
          },
          win_options = {
            winhighlight = {
              Normal = "NormalFloat",
              FloatBorder = "FloatBorder",
            },
          },
        },
        notify = {
          border = { style = env.borders.main },
          relative = "editor",
        },
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            event = "lsp",
            kind = "progress",
            find = "Processing file symbols...",
          },
          opts = {
            skip = true,
          },
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {},
    enabled = false,
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
      columns = {
        "icon",
        "type",
        "permissions",
        "birthtime",
        "atime",
        "mtime",
        "size",
      },
      delete_to_trash = true,
      float = {
        padding = 4,
        border = env.borders.main,
      },
      preview = {
        max_width = 0.7,
        min_width = { 40, 0.4 },
        border = env.borders.main,
        win_options = {
          winblend = 5,
        },
      },
      progress = {
        max_width = 0.45,
        min_width = { 40, 0.2 },
        border = env.borders.main,
        minimized_border = env.borders.main,
        win_options = {
          winblend = 5,
        },
      },
      keymaps = {
        ["."] = "actions.cd",
        ["`"] = false,
        ["<C-t>"] = false,
        ["<BS>"] = "actions.parent",
        ["-"] = "actions.parent",
      },
    },
    keys = {
      {
        key_oil .. "o",
        function()
          return require("oil").open_float()
        end,
        mode = { "n", "v" },
        desc = "oil=> open oil (float)",
      },
      {
        key_oil .. "O",
        function()
          return require("oil").open()
        end,
        mode = { "n", "v" },
        desc = "oil=> open oil (not float)",
      },
      {
        key_oil .. "q",
        function()
          return require("oil").close()
        end,
        mode = { "n", "v" },
        desc = "oil=> close oil",
      },
      {
        "<leader>e",
        function()
          return require("oil").open_float()
        end,
        mode = { "n", "v" },
        desc = "oil => float oil",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "oil" },
        group = vim.api.nvim_create_augroup("oil_quit_on_q", {}),
        callback = function()
          vim.keymap.set(
            "n",
            "q",
            "<CMD>quit<CR>",
            { buffer = true, desc = "quit", remap = false }
          )
        end,
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = {
      open_mapping = "<C-;>",
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
        pattern = { "oil" },
        group = vim.api.nvim_create_augroup("oil_quit_on_q", {}),
        callback = function()
          vim.keymap.set(
            "n",
            "q",
            "<CMD>quit<CR>",
            { buffer = true, desc = "quit", remap = false }
          )
        end,
      })
    end,
  },
  {
    "nvim-focus/focus.nvim",
    enabled = true,
    opts = {
      enable = true,
      commands = true,
      autoresize = {
        enable = true,
      },
      ui = {
        absolutenumber_unfocussed = true,
        hybridnumber = true,
        winhighlight = false,
        cursorline = true,
        cursorcolumn = false,
        colorcolumn = {
          enable = true,
          list = "+1",
        },
      },
    },
    event = "VeryLazy",
    init = function()
      local focus = require("focus")
      local focusmap = function(direction)
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>w" .. direction,
          -- this comes directly from  the focus nvim readme but we want to use the capital letter mappings for consistency
          ":lua require'focus'.split_command('"
            .. string.lower(direction)
            .. "')<CR>",
          { silent = true }
        )
      end
      -- Use `<Leader>h` to split the screen to the left, same as command FocusSplitLeft etc
      focusmap("h")
      focusmap("j")
      focusmap("k")
      focusmap("l")
      mapx(
        "n",
        "<leader>uWw",
        focus.focus_toggle,
        { desc = "focus=> toggle focus win-sizer" }
      )
      mapx(
        "n",
        "<leader>uWo",
        focus.focus_enable,
        { desc = "focus=> enable focus win-sizer" }
      )
      mapx(
        "n",
        "<leader>uWq",
        focus.focus_disable,
        { desc = "focus=> disable focus win-sizer" }
      )
      mapx(
        "n",
        "<leader>uWM",
        focus.focus_max_or_equal,
        { desc = "focus=> toggle maximized focus" }
      )

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "Outline" },
        group = vim.api.nvim_create_augroup("enable_focus_for_docsymbols", {}),
        callback = require("focus").focus_enable_window,
      })
    end,
  },
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      render = function(props)
        return {
          { require("noice").api.status.mode.get() },
          -- { pomodoro() },
          -- { filesize() },
          { memory_use() },
        }
      end,
      window = {
        margin = { vertical = 1, horizontal = 1 },
        padding = { left = 1, right = 1 },
        placement = { horizontal = "right", vertical = "top" },
        width = "fit",
        options = {
          winblend = 20,
          signcolumn = "no",
          wrap = false,
          -- border = env.borders.main,
        },
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
    "f-person/git-blame.nvim",
    cmd = { "GitBlameToggle", "GitBlameEnable" },
    init = function()
      vim.g.gitblame_delay = 1000
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    enabled = true,
    event = { "VeryLazy" },
    cmd = { "Neogit" },
    opts = {
      integrations = { diffview = true },
    },
    keys = {
      {
        key_git .. "n",
        "<CMD>Neogit<CR>",
        mode = { "n", "v" },
        desc = "git=> neogit",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "folke/noice.nvim",
      "nvim-tree/nvim-web-devicons",
      "meuter/lualine-so-fancy.nvim",
      "Bekaboo/dropbar.nvim",
      "rebelot/kanagawa.nvim",
    },
    event = "VimEnter",
    opts = {
      options = {
        theme = "auto",
        icons_enabled = true,
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        refresh = {
          statusline = 10,
          tabline = 10,
          winbar = 10,
        },
        disabled_filetypes = {
          winbar = {
            "oil",
            "Outline",
            "dashboard",
            "fzf",
            "trouble",
          },
        },
      },
      sections = {
        lualine_a = { { "fancy_mode", width = 7 } },
        lualine_b = { { "b:gitsigns_head", icon = "" } },
        lualine_c = {
          {
            "fancy_cwd",
            substitute_home = true,
          },
        },
        lualine_x = {
          {
            require("noice").api.status.command.get,
          },
          {
            "filetype",
            icon_only = false,
            padding = { left = 2, right = 1 },
          },
          {
            "fancy_location",
          },
          {
            "fancy_searchcount",
          },
        },
        lualine_y = {
          {
            "fancy_lsp_servers",
          },
        },
        lualine_z = {
          {
            "datetime",
            style = "%Y-%m-%d %H:%M",
          },
        },
      },
      tabline = {
        lualine_a = {
          {
            "buffers",
            show_filename_only = false,
            mode = 4,
            use_mode_colors = true,
          },
        },
        lualine_x = {
          {
            require("noice").api.status.mode.get,
            cond = require("noice").api.status.mode.has,
            color = {
              fg = require("kanagawa.colors").setup({ theme = "wave" }).palette.dragonRed,
            },
          },
          {
            custom_fname,
            path = 0,
            symbols = {
              modified = "",
              readonly = "󱪛",
              unnamed = "",
              newfile = "",
            },
          },
        },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "%{%v:lua.dropbar.get_dropbar_str()%}",
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = {
              error = require("lazyvim.config").icons.diagnostics.Error,
              warn = require("lazyvim.config").icons.diagnostics.Warn,
              info = require("lazyvim.config").icons.diagnostics.Info,
              hint = require("lazyvim.config").icons.diagnostics.Hint,
            },
          },
        },
        lualine_y = {
          {
            "diff",
            colored = true,
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
            source = diff_source,
          },
        },
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    },
  },
  {
    "code-biscuits/nvim-biscuits",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = true,
    opts = {
      cursor_line_only = true,
      toggle_keybind = "<leader>uu",
      show_on_start = true,
    },
    event = { "LspAttach" },
    build = ":TSUpdate",
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
        style = "inline",
      },
      modes = {
        char = {
          keys = { "f", "F", "t", "T", "," },
        },
      },
    },
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
            { buffer = true, desc = "quit", remap = false }
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
        vim.api.nvim_win_set_config(win, {
          border = env.borders.main,
        })
      end
    end,
  },
  {
    "VidocqH/lsp-lens.nvim",
    enabled = true,
    opts = {
      enable = true,
      include_declaration = false,
      sections = {
        definition = true,
        references = true,
        implements = true,
      },
      ignore_filetype = { "prisma" },
    },
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    keys = {
      {
        key_lens .. "o",
        "<CMD>LspLensToggle<CR>",
        mode = { "n" },
        desc = "lens.lsp=> toggle",
      },
      {
        key_lens .. "O",
        "<CMD>LspLensOn<CR>",
        mode = { "n" },
        desc = "lens.lsp=> on",
      },
      {
        key_lens .. "q",
        "<CMD>LspLensOff<CR>",
        mode = { "n" },
        desc = "lens.lsp=> off",
      },
    },
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
  {
    dependencies = { "nvim-lua/plenary.nvim" },
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      position = "left",
      width = 28,
      auto_close = false,
      auto_preview = false,
      winblend = 15,
      keymaps = {
        close = { "qq" },
        toggle_preview = "<C-Space>",
        hover_symbol = "K",
        fold_all = "M",
        unfold_all = "R",
        fold_reset = "zW",
      },
      symbols = {
        event = { icon = "", hl = "@type" },
      },
    },
    config = true,
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
    "bennypowers/nvim-regexplainer",
    config = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
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
        "<leader>qq",
        require("nvim-smartbufs").close_current_buffer,
        { desc = "buf=> close current buffer" }
      )
      -- mapx(
      --   { "n", "v" },
      --   "<leader>Q",
      --   require("nvim-smartbufs").close_current_buffer,
      --   { desc = "buf=> close current buffer" }
      -- )
      mapx(
        { "n", "v" },
        "<leader>qQ",
        "<CMD>qa<CR>",
        { desc = "buf=> close all buffers" }
      )
      mapx(
        { "n", "v" },
        "<leader>QQ",
        "<CMD>qa!<CR>",
        { desc = "buf=> close all buffers immediately" }
      )
      mapx(
        { "n", "v" },
        "<leader>b[",
        require("nvim-smartbufs").goto_prev_buffer,
        { desc = "buf=> previous buffer" }
      )
      mapx(
        { "n", "v" },
        "<leader>b]",
        require("nvim-smartbufs").goto_next_buffer,
        { desc = "buf=> next buffer" }
      )
      mapx(
        { "n", "v", "i" },
        "<C-S-Left>",
        require("nvim-smartbufs").goto_prev_buffer,
        { desc = "buf=> previous buffer" }
      )
      mapx(
        { "n", "v", "i" },
        "<C-S-Right>",
        require("nvim-smartbufs").goto_next_buffer,
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
        require("nvim-smartbufs").close_current_buffer,
        { desc = "buf=> close current buffer" }
      )
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    version = "*",
    event = "VeryLazy",
    opts = {
      general = {
        enable = false,
      },
      menu = {
        win_configs = {
          border = env.borders.main,
          style = "minimal",
        },
      },
    },
    init = function()
      mapx(
        { "n", "v", "o" },
        "g-",
        require("dropbar.api").pick,
        { desc = "lsp=> dropbar inspect symbols" }
      )
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.plugins = vim.tbl_extend("force", {

        marks = false,
        registers = true,
      }, opts.plugins or {})
      opts.window = vim.tbl_extend("force", {
        border = env.borders.main,
        winblend = 5,
        zindex = 1000,
      }, opts.window or {})
      opts.triggers_nowait = { --vim.table_extend("force", {
        "g`",
        "g'",
        -- registers
        '"',
        "<c-r>",
        -- spelling
        "z=",
      }
      opts.documentation = {
        view = "hover",
        opts = {
          lang = "markdown",
          replace = true,
          render = "plain",
          format = { "{message}" },
          win_options = { concealcursor = "n", conceallevel = 3 },
        },
      }
    end,
  }, -- mason.nvim integration
  {
    "lewis6991/satellite.nvim",
    opts = {
      current_only = true,
      winblend = 50,
      zindex = 40,
      excluded_filetypes = {
        "oil",
        "Outline",
        "dashboard",
        "fzf",
        "trouble",
      },
      width = 2,
      search = {
        enable = true,
      },
      diagnostic = {
        enable = true,
        signs = { "-", "=", "≡" },
        min_severity = vim.diagnostic.severity.HINT,
      },
      gitsigns = {
        enable = true,
        signs = {
          add = "|",
          change = "|",
          delete = "-",
        },
      },
      marks = {
        enable = true,
        show_builtins = false,
        key = "m",
      },
      quickfix = {
        signs = { "-", "=", "≡" },
      },
    },
    config = true,
    event = "VeryLazy",
  },
  {
    "jghauser/mkdir.nvim",
    config = function() end,
    event = "VeryLazy",
  },
  {
    "mawkler/modicator.nvim",
    config = true,
    enabled = false,
    opts = {},
    init = function()
      -- These are required for Modicator to work
      vim.o.cursorline = true
      vim.o.number = true
      vim.o.termguicolors = true
    end,
    event = "VeryLazy",
  },
  {
    "stevearc/dressing.nvim",
    event = "BufReadPre",
    config = true,
    opts = {
      input = {
        relative = "editor",
      },
      select = {
        backend = { "telescope", "fzf", "builtin" },
      },
    },
  },
  -- this is just to load navbuddy before the lspconfig setup.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        keys = {
          {
            "<leader>`",
            function()
              require("nvim-navbuddy").open()
            end,
            mode = "n",
            desc = "nav=> open navbuddy",
          },
        },
        opts = {
          lsp = { auto_attach = true },
          window = {
            border = env.borders.main,
            size = "70%",
            position = "50%",
            scrolloff = true,
            left = {
              size = "20%",
              border = nil,
            },
            mid = {
              size = "40%",
              border = nil,
            },
            right = {
              border = nil,
              preview = "leaf",
            },
          },
        },
      },
    },
    -- your lsp config or other stuff
  },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "glepnir/template.nvim",
    cmd = { "Template", "TemProject" },
    config = true,
    opts = {
      temp_dir = "~/.config/nvim/templates",
    },
  },
  { "mrjones2014/smart-splits.nvim", event = "VeryLazy" },
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
        "<leader>R" .. "r",
        "<Plug>RestNvim",
        mode = "n",
        desc = "rest=> open rest client",
        remap = true,
      },
      {
        "<leader>R" .. "p",
        "<Plug>RestNvimPreview",
        mode = "n",
        desc = "rest=> open rest preview",
        remap = true,
      },
      {
        "<leader>R" .. "l",
        "<Plug>RestNvimLast",
        mode = "n",
        desc = "rest=> open last used rest client",
        remap = true,
      },
    },
  },
  {
    "anuvyklack/pretty-fold.nvim",
    config = true,
    event = "VeryLazy",
    opts = {
      sections = {
        left = {
          "content",
        },
        right = {
          " ",
          "number_of_folded_lines",
          ": ",
          "percentage",
          " ",
          function(config)
            return config.fill_char:rep(3)
          end,
        },
      },
      fill_char = "🮧",

      remove_fold_markers = true,

      -- Keep the indentation of the content of the fold string.
      keep_indentation = true,

      -- Possible values:
      -- "delete" : Delete all comment signs from the fold string.
      -- "spaces" : Replace all comment signs with equal number of spaces.
      -- false    : Do nothing with comment signs.
      process_comment_signs = "spaces",

      -- Comment signs additional to the value of `&commentstring` option.
      comment_signs = {},

      -- List of patterns that will be removed from content foldtext section.
      stop_words = {
        "@brief%s*", -- (for C++) Remove '@brief' and all spaces after.
      },

      add_close_pattern = true, -- true, 'last_line' or false

      matchup_patterns = {
        { "{", "}" },
        { "%(", ")" }, -- % to escape lua pattern char
        { "%[", "]" }, -- % to escape lua pattern char
      },

      ft_ignore = { "neorg" },
    },
  },
  {
    "mvllow/modes.nvim",
    tag = "v0.2.0",
    config = true,
    opts = {
      colors = {
        copy = kanacolor.boatYellow2,
        delete = kanacolor.peachRed,
        insert = kanacolor.springBlue,
        visual = kanacolor.springViolet1,
      },
    },
    event = "VeryLazy",
  },
  {
    "haringsrob/nvim_context_vt",
    enabled = false,
    event = "VeryLazy",
    cmd = { "NvimContextVtToggle" },
    keys = {
      {
        "<leader>uX",
        "<CMD>NvimContextVtToggle<CR>",
        mode = "n",
        desc = "ctx=> toggle code context labeling",
      },
    },
    opts = {
      -- Enable by default. You can disable and use :NvimContextVtToggle to maually enable.
      -- Default: true
      enabled = true,

      -- Override default virtual text prefix
      -- Default: '-->'
      prefix = "󰟵",

      -- Override the internal highlight group name
      -- Default: 'ContextVt'
      highlight = "CustomContextVt",

      -- Disable virtual text for given filetypes
      -- Default: { 'markdown' }
      disable_ft = { "markdown" },

      -- Disable display of virtual text below blocks for indentation based languages like Python
      -- Default: false
      disable_virtual_lines = false,

      -- Same as above but only for spesific filetypes
      -- Default: {}
      disable_virtual_lines_ft = { "yaml" },

      -- How many lines required after starting position to show virtual text
      -- Default: 1 (equals two lines total)
      min_rows = 1,

      -- Same as above but only for spesific filetypes
      -- Default: {}
      min_rows_ft = {},

      -- Custom virtual text node parser callback
      -- Default: nil
      custom_parser = function(node, ft, opts)
        local utils = require("nvim_context_vt.utils")

        -- If you return `nil`, no virtual text will be displayed.
        if node:type() == "function" then
          return nil
        end

        -- This is the standard text
        return "--> " .. utils.get_node_text(node)[1]
      end,

      -- Custom node validator callback
      -- Default: nil
      custom_validator = function(node, ft, opts)
        -- Internally a node is matched against min_rows and configured targets
        local default_validator =
          require("nvim_context_vt.utils").default_validator
        if default_validator(node, ft) then
          -- Custom behaviour after using the internal validator
          if node:type() == "function" then
            return false
          end
        end

        return true
      end,

      -- Custom node virtual text resolver callback
      -- Default: nil
      custom_resolver = function(nodes, ft, opts)
        -- By default the last node is used
        return nodes[#nodes]
      end,
    },
  },
  {
    "Pocco81/auto-save.nvim",
    opts = {
      enabled = false, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
      execution_message = {
        message = function() -- message to print on save
          return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
        end,
        dim = 0.18, -- dim the color of `message`
        cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
      },
      trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
      -- function that determines whether to save the current buffer or not
      -- return true: if buffer is ok to be saved
      -- return false: if it's not ok to be saved
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        if
          fn.getbufvar(buf, "&modifiable") == 1
          and utils.not_in(fn.getbufvar(buf, "&filetype"), {})
        then
          return true -- met condition(s), can save
        end
        return false -- can't save
      end,
      write_all_buffers = false, -- write all buffers when the current one meets `condition`
      debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
      callbacks = { -- functions to be executed at different intervals
        enabling = nil, -- ran when enabling auto-save
        disabling = nil, -- ran when disabling auto-save
        before_asserting_save = nil, -- ran before checking `condition`
        before_saving = nil, -- ran before doing the actual save
        after_saving = nil, -- ran after doing the actual save
      },
    },
    keys = {
      {
        "<leader>uS",
        "<CMD>ASToggle<CR>",
        mode = "n",
        desc = "ui=> toggle auto save",
      },
    },
    cmd = "ASToggle",
  },
  {
    "kevinhwang91/nvim-hlslens",
    enabled = true,
    config = true,
    event = "VeryLazy",
    opts = {
      auto_enable = {
        description = [[Enable nvim-hlslens automatically]],
        default = true,
      },
      enable_incsearch = {
        description = [[When `incsearch` option is on and enable_incsearch is true, add lens
            for the current matched instance]],
        default = false,
      },
      calm_down = {
        description = [[If calm_down is true, clear all lens and highlighting When the cursor is
            out of the position range of the matched instance or any texts are changed]],
        default = true,
      },
      nearest_only = {
        description = [[Only add lens for the nearest matched instance and ignore others]],
        default = false,
      },
      nearest_float_when = {
        description = [[When to open the floating window for the nearest lens.
            'auto': floating window will be opened if room isn't enough for virtual text;
            'always': always use floating window instead of virtual text;
            'never': never use floating window for the nearest lens]],
        default = "auto",
      },
      float_shadow_blend = {
        description = [[Winblend of the nearest floating window. `:h winbl` for more details]],
        default = 30,
      },
      virt_priority = {
        description = [[Priority of virtual text, set it lower to overlay others.
        `:h nvim_buf_set_extmark` for more details]],
        default = 100,
      },
      override_lens = {
        description = [[Hackable function for customizing the lens. If you like hacking, you
            should search `override_lens` and inspect the corresponding source code.
            There's no guarantee that this function will not be changed in the future. If it is
            changed, it will be listed in the CHANGES file.
            @param render table an inner module for hlslens, use `setVirt` to set virtual text
            @param splist table (1,1)-indexed position
            @param nearest boolean whether nearest lens
            @param idx number nearest index in the plist
            @param relIdx number relative index, negative means before current position,
                                  positive means after
        ]],
        default = nil,
      },
    },
    keys = {
      {
        "<leader>uL",
        "<CMD>HlSearchLensToggle<CR>",
        mode = "n",
        desc = "lens=> toggle search results lens",
      },
    },
    cmd = {
      "HlSearchLensToggle",
      "HlSearchLensEnable",
      "HlSearchLensDisable",
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
    "winston0410/range-highlight.nvim",
    config = function() end,
    opts = {},
    event = "VeryLazy",
  },
  {
    "nvim-zh/better-escape.vim",
    config = function()
      vim.g.better_escape_shortcut = "jj"
    end,
    event = "InsertEnter",
  },
  {
    "arsham/archer.nvim",
    event = "VeryLazy",
    dependencies = { "arsham/arshlib.nvim" },
    config = true,
  },
}
