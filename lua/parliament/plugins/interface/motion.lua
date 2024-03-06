local env = require("environment.ui")
local opt = require("environment.optional")
local kenv = require("environment.keys").motion.standard
local qenv = require("environment.keys").motion.qortal
local ui_keys = require("environment.keys").ui

return {
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    version = false,
    opts = {
      buffer = { suffix = "b", options = {} },
      comment = { suffix = "c", options = {} },
      conflict = { suffix = "g", options = {} },
      diagnostic = { suffix = "d", options = {} },
      file = { suffix = "f", options = {} },
      indent = { suffix = "n", options = {} },
      jump = { suffix = "j", options = {} },
      location = { suffix = "l", options = {} },
      oldfile = { suffix = "o", options = {} },
      quickfix = { suffix = "q", options = {} },
      treesitter = { suffix = "e", options = {} },
      undo = { suffix = "u", options = {} },
      window = { suffix = "w", options = {} },
      yank = { suffix = "y", options = {} },
    },
    config = function(_, opts)
      require("mini.bracketed").setup(opts)
    end,
  },
  {
    "abecodes/tabout.nvim",
    enabled = opt.tabout,
    event = "VeryLazy",
    opts = {
      tabkey = "<Tab>",
      backwards_tabkey = "<S-Tab>",
      act_as_tab = true,
      act_as_shift_tab = false,
      default_tab = "<C-t>",
      default_shift_tab = "<C-d>",
      enable_backwards = true,
      completion = true,
      tabouts = {
        { open = "'", close = "'" },
        { open = "\"", close = "\"" },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
      },
      ignore_beginning = true,
      exclude = {},
    },
    config = function(_, opts)
      require("tabout").setup(opts)
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },
  {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      log_level = "warn",
      scope = "git",
      save_path = tostring(vim.fn.stdpath("data") .. "/grapple"),
      ---Window options used for the popup menu
      popup_options = {
        relative = "editor",
        width = 60,
        height = 12,
        style = "minimal",
        focusable = false,
        border = env.borders.main,
      },
      integrations = {
        ---Support for saving tag state using resession.nvim
        resession = false,
      },
    },
    keys = {
      {
        kenv.grapple.toggle,
        function()
          require("grapple").toggle()
        end,
        mode = "n",
        desc = "grapple:| tag |=> toggle",
      },
      {
        kenv.grapple.popup,
        function()
          require("grapple").popup_tags()
        end,
        mode = "n",
        desc = "grapple:| pop |=> tags view",
      },
      {
        kenv.grapple.tag,
        function()
          require("grapple").tag()
        end,
        mode = "n",
        desc = "grapple:| tag |=> named",
      },
      {
        kenv.grapple.untag,
        function()
          require("grapple").untag()
        end,
        mode = "n",
        desc = "grapple:| untag |=> named",
      },
      {
        kenv.grapple.select,
        function()
          require("grapple").select()
        end,
        mode = "n",
        desc = "grapple:| tag |=> select",
      },
      {
        kenv.grapple.quickfix,
        function()
          require("grapple").quickfix()
        end,
        mode = "n",
        desc = "grapple:| tag |=> to quickfix",
      },
      {
        kenv.grapple.reset,
        function()
          require("grapple").reset()
        end,
        mode = "n",
        desc = "grapple:| tag |=> ~reset~",
      },
      {
        kenv.grapple.cycle.backward,
        function()
          require("grapple").cycle_backward()
        end,
        mode = "n",
        desc = "grapple:| tag |=> cycle backward",
      },
      {
        kenv.grapple.cycle.forward,
        function()
          require("grapple").cycle_forward()
        end,
        mode = "n",
        desc = "grapple:| tag |=> cycle forward",
      },
      {
        kenv.grapple.list_tags,
        function()
          require("grapple").tags()
        end,
        mode = "n",
        desc = "grapple:| tag |=> list tags",
      },
    },
  },
  {
    "cbochs/portal.nvim",
    keys = {
      {
        qenv.changelist.forward,
        function()
          require("portal.builtin").changelist.tunnel()
        end,
        mode = "n",
        desc = "portal:| chng |=> forward",
      },
      {
        qenv.changelist.backward,
        function()
          require("portal.builtin").changelist.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| chng |=> backward",
      },
      {
        qenv.grapple.forward,
        function()
          require("portal.builtin").grapple.tunnel()
        end,
        mode = "n",
        desc = "portal:| grpl |=> forward",
      },
      {
        qenv.grapple.backward,
        function()
          require("portal.builtin").grapple.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| grpl |=> backward",
      },
      {
        qenv.quickfix.forward,
        function()
          require("portal.builtin").quickfix.tunnel()
        end,
        mode = "n",
        desc = "portal:| qf |=> forward",
      },
      {
        qenv.quickfix.backward,
        function()
          require("portal.builtin").quickfix.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| qf |=> backward",
      },
      {
        qenv.jumplist.forward,
        function()
          require("portal.builtin").jumplist.tunnel()
        end,
        mode = "n",
        desc = "portal:| jump |=> backward",
      },
      {
        qenv.jumplist.backward,
        function()
          require("portal.builtin").jumplist.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| jump |=> forward",
      },
      {
        qenv.harpoon.forward,
        function()
          require("portal.builtin").harpoon.tunnel()
        end,
        mode = "n",
        desc = "portal:| hrpn |=> forward",
      },
      {
        qenv.harpoon.backward,
        function()
          require("portal.builtin").harpoon.tunnel_backward()
        end,
        mode = "n",
        desc = "portal:| hrpn |=> forward",
      },
    },
    opts = {
      ---@type "debug" | "info" | "warn" | "error"
      log_level = "debug",

      ---The base filter applied to every search.
      ---@type Portal.SearchPredicate | nil
      filter = nil,

      ---The maximum number of results for any search.
      ---@type integer | nil
      max_results = nil,

      ---The maximum number of items that can be searched.
      ---@type integer
      lookback = 100,

      ---An ordered list of keys for labelling portals.
      ---Labels will be applied in order, or to match slotted results.
      ---@type string[]
      labels = { "a", "b", "c", "d", "e" },

      ---Select the first portal when there is only one result.
      select_first = true,

      ---Keys used for exiting portal selection. Disable with [{key}] = false
      ---to `false`.
      ---@type table<string, boolean>
      escape = { ["<esc>"] = true, ["q"] = true },

      ---The raw window options used for the portal window
      window_options = {
        relative = "cursor",
        width = 60,
        height = 3,
        col = 2,
        focusable = false,
        border = env.borders.alt,
        noautocmd = true,
      },
    },
    -- init = function()
    --   local function deleter(it)
    --     if type(it) == "table" then
    --       vim.tbl_map(deleter, it)
    --     else
    --       vim.keymap.set("n", it, "<nop>")
    --     end
    --   end
    --   vim.tbl_map(deleter, qenv)
    -- end,
    config = function(_, opts)
      require("portal").setup(opts)
    end,
    cmd = { "Portal" },
    dependencies = { "cbochs/grapple.nvim" },
  },
  {
    "roobert/tabtree.nvim",
    config = function(_, opts)
      require("tabtree").setup(opts)
    end,
    event = "VeryLazy",
    opts = {
      -- print the capture group name when executing next/previous
      debug = true,
      -- disable key bindings
      -- key_bindings_disabled = true,
      key_bindings = { next = "<Tab>", previous = "<S-Tab>" },
      -- use TSPlaygroundToggle to discover the (capture group)
      -- @capture_name can be anything
      language_configs = {
        python = {
          target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
            ]],
          -- experimental feature, to move the cursor in certain situations like when handling python f-strings
          offsets = { string_start_capture = 1 },
        },
      },
      default_config = {
        target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
          ]],
        offsets = {},
      },
    },
  },
  {
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      label = { rainbow = { enabled = true, shade = 4 }, style = "overlay" },
      modes = { char = { keys = { "f", "F", "t", "T", "," } } },
      jump = { autojump = true },
    },
    keys = {
      { "s", false, mode = { "n", "x", "o" } },
      { "S", false, mode = { "n", "x", "o" } },
      {
        "<CR>",
        function()
          require("flash").jump()
        end,
        mode = { "n", "x", "o" },
        desc = "::flash=> jump to",
      },
      {
        "<C-CR>",
        function()
          require("flash").treesitter()
        end,
        mode = { "n", "x", "o" },
        desc = "::flash=> jump treesitter",
      },
    },
  },
  {
    "boltlessengineer/smart-tab.nvim",
    opts = { mapping = "<tab>" },
    event = "VeryLazy",
    config = function(_, opts)
      require("smart-tab").setup(opts)
    end,
  },
  {
    "PeterRincker/vim-argumentative",
    opts = {},
    config = function(_, opts) end,
    event = "VeryLazy",
  },
  {
    "VidocqH/auto-indent.nvim",
    event = "VeryLazy",
    opts = {
      lightmode = true,
      indentexpr = nil,
      ignore_filetype = env.ft_ignore_list,
    },
    config = function(_, opts)
      require("auto-indent").setup(opts)
    end,
  },
  {
    "jinh0/eyeliner.nvim",
    config = function(_, opts)
      require("eyeliner").setup(opts)
    end,
    opts = {},
    event = "VeryLazy",
    init = function()
      vim.api.nvim_set_hl(
        0,
        "EyelinerPrimary",
        { bold = true, underline = true }
      )
      vim.api.nvim_set_hl(0, "EyelinerSecondary", { underline = true })
    end,
    keys = {
      {
        ui_keys.eyeliner,
        function()
          vim.cmd([[EyelinerToggle]])
        end,
        mode = "n",
        desc = "ui:| liner |=> toggle",
      },
    },
  },
}
