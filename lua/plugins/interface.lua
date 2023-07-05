local env = require("environment.ui")
local stems = require("environment.keys").stems
local mapn = require("environment.keys").map("n")
local mapx = vim.keymap.set
local key_notify = stems.notify
local key_vista = stems.vista
local key_lens = stems.lens
local key_git = stems.git
local key_oil = stems.oil

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
        popup = {
          border = { style = env.borders.main },
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
    init = function()
      mapx(
        { "n", "v" },
        key_oil .. "o",
        require("oil").open_float,
        { desc = "oil=> open oil (float)" }
      )
      mapx(
        { "n", "v" },
        key_oil .. "O",
        require("oil").open,
        { desc = "oil=> open oil (not float)" }
      )
      mapx(
        { "n", "v" },
        key_oil .. "q",
        require("oil").close,
        { desc = "oil=> close oil" }
      )
      mapx(
        { "n", "v" },
        "<leader>e",
        require("oil").open_float,
        { desc = "oil => float oil" }
      )
      mapx(
        "n",
        "-",
        require("oil").open,
        { desc = "oil=> open parent directory" }
      )

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
    opts = function(_, opts)
      table.insert(opts, {
        open_mapping = "<C-`>",
        float_opts = {
          border = env.borders.main,
          winblend = 5,
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
        shading_factor = 5,
      })
    end,
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

      mapx({ "n", "t" }, "<leader>tv", function()
        require("toggleterm").setup({ direction = "vertical" })
      end, { desc = "toggle terminals vertically" })
      mapx({ "n", "t" }, "<leader>th", function()
        require("toggleterm").setup({ direction = "horizontal" })
      end, { desc = "toggle terminals horizontally" })
      mapx({ "n", "t" }, "<leader>tf", function()
        require("toggleterm").setup({ direction = "float" })
      end, { desc = "toggle floating terminals" })
      mapx({ "n", "t" }, "<leader>tb", function()
        require("toggleterm").setup({ direction = "tabbed" })
      end, { desc = "toggle terminals vertically" })
    end,
  },
  {
    "nvim-focus/focus.nvim",
    opts = {
      enable = true,
      winhighlight = false,
      hybridnumber = true,
      absolutenumber_unfocussed = true,
    },
    event = "VeryLazy",
    init = function()
      local focus = require("focus")
      local focusmap = function(direction)
        vim.api.nvim_set_keymap(
          "n",
          "<Leader>" .. direction,
          -- this comes directly from  the focus nvim readme but we want to use the capital letter mappings for consistency
          ":lua require'focus'.split_command('"
            .. string.lower(direction)
            .. "')<CR>",
          { silent = true }
        )
      end
      -- Use `<Leader>h` to split the screen to the left, same as command FocusSplitLeft etc
      focusmap("H")
      focusmap("J")
      focusmap("K")
      focusmap("L")
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
          "dashboard",
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
    enabled = false,
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
      include_declaration = true,
      sections = {
        definition = true,
        references = true,
        implementation = true,
      },
      ignore_filetype = { "prisma" },
    },
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    keys = {
      {
        key_lens .. "t",
        "<CMD>LspLensToggle<CR>",
        mode = { "n" },
        desc = "lens=> toggle",
      },
      {
        key_lens .. "o",
        "<CMD>LspLensOn<CR>",
        mode = { "n" },
        desc = "lens=> on",
      },
      {
        key_lens .. "q",
        "<CMD>LspLensOff<CR>",
        mode = { "n" },
        desc = "lens=> off",
      },
      {
        "<leader>uE",
        "<CMD>LspLensToggle<CR>",
        mode = { "n" },
        desc = "lens=> toggle",
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
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    enabled = false,
  },
  {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline", "SymbolsOutlineOpen", "SymbolsOutlineClose" },
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
    "SmiteshP/nvim-navic",
    enabled = false,
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
      mapx(
        { "n", "v" },
        "<leader>Q",
        require("nvim-smartbufs").close_current_buffer,
        { desc = "buf=> close current buffer" }
      )
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
}
