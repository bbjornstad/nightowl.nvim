local env = require("environment.ui")
local opt = require("environment.optional")
local kenv = require("environment.keys")

local key_portal = kenv.motion.portal
local key_grapple_tag = kenv.motion.grapple.tag

return {
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    version = false,
  },
  {
    "rainbowhxch/accelerated-jk.nvim",
    enabled = opt.accelerated_jk.enable,
    event = "VeryLazy",
    opts = {
      mode = "time_driven",
      enable_deceleration = false,
      acceleration_motions = { "j", "k", "e", "w", "b" },
      acceleration_limit = 120,
      acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
      -- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
      deceleration_table = { { 150, 9999 } },
    },
    config = true,
  },
  {
    "abecodes/tabout.nvim",
    enabled = opt.tabout.enable,
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
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
  },
  {
    "cbochs/grapple.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
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
        key_grapple_tag .. "g",
        function()
          require("grapple").toggle()
        end,
        mode = "n",
        desc = "grapple.tag=> toggle",
      },
      {
        key_grapple_tag .. "p",
        function()
          require("grapple").popup_tags()
        end,
        mode = "n",
        desc = "grapple.pop=> tags view",
      },
      {
        key_grapple_tag .. "t",
        function()
          require("grapple").tag()
        end,
        mode = "n",
        desc = "grapple.tag=> tag (named)",
      },
      {
        key_grapple_tag .. "u",
        function()
          require("grapple").untag()
        end,
        mode = "n",
        desc = "grapple.tag=> untag (named)",
      },
      {
        key_grapple_tag .. "s",
        function()
          require("grapple").select()
        end,
        mode = "n",
        desc = "grapple.tag=> select",
      },
      {
        key_grapple_tag .. "q",
        function()
          require("grapple").quickfix()
        end,
        mode = "n",
        desc = "grapple.tag=> to quickfix",
      },
      {
        key_grapple_tag .. "dd",
        function()
          require("grapple").reset()
        end,
        mode = "n",
        desc = "grapple.tag=> ~reset~",
      },
      {
        key_grapple_tag .. "C",
        function()
          require("grapple").cycle_backward()
        end,
        mode = "n",
        desc = "grapple.tag=> cycle backward",
      },
      {
        key_grapple_tag .. "c",
        function()
          require("grapple").cycle_forward()
        end,
        mode = "n",
        desc = "grapple.tag=> cycle forward",
      },
      {
        key_grapple_tag .. "u",
        function()
          require("grapple").untag()
        end,
        mode = "n",
        desc = "grapple.tag=> untag (named)",
      },
      {
        key_grapple_tag .. "T",
        function()
          require("grapple").tags()
        end,
        mode = "n",
        desc = "grapple.tag=> list tags",
      },
    },
  },
  {
    "cbochs/portal.nvim",
    keys = {
      {
        key_portal .. "c",
        function()
          require("portal.builtin").changelist.tunnel()
        end,
        mode = "n",
        desc = "portal=> forward changelist",
      },
      {
        key_portal .. "C",
        function()
          require("portal.builtin").changelist.tunnel_backward()
        end,
        mode = "n",
        desc = "portal=> backward changelist",
      },
      {
        key_portal .. "g",
        function()
          require("portal.builtin").grapple.tunnel()
        end,
        mode = "n",
        desc = "portal=> forward grapple",
      },
      {
        key_portal .. "G",
        function()
          require("portal.builtin").grapple.tunnel_backward()
        end,
        mode = "n",
        desc = "portal=> backward grapple",
      },
      {
        key_portal .. "q",
        function()
          require("portal.builtin").quickfix.tunnel()
        end,
        mode = "n",
        desc = "portal=> forward quickfix",
      },
      {
        key_portal .. "Q",
        function()
          require("portal.builtin").quickfix.tunnel_backward()
        end,
        mode = "n",
        desc = "portal=> backward quickfix",
      },
      {
        key_portal .. "j",
        function()
          require("portal.builtin").jumplist.tunnel()
        end,
        mode = "n",
        desc = "portal=> backward jumplist",
      },
      {
        key_portal .. "J",
        function()
          require("portal.builtin").jumplist.tunnel_backward()
        end,
        mode = "n",
        desc = "portal=> forward jumplist",
      },
      {
        key_portal .. "f",
        function()
          require("portal.builtin").jumplist.tunnel()
        end,
        mode = "n",
        desc = "portal=> forward jumplist",
      },
      {
        key_portal .. "b",
        function()
          require("portal.builtin").jumplist.tunnel_backward()
        end,
        mode = "n",
        desc = "portal=> backward jumplist",
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
      escape = {
        ["<esc>"] = true,
        ["q"] = true,
        ["qq"] = true,
      },

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
    config = true,
    cmd = { "Portal" },
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
    },
  },
  {
    "roobert/tabtree.nvim",
    config = function(_, opts)
      require("tabtree").setup(opts)
    end,
    event = "VeryLazy",
    enabled = opt.tabtree.enable,
    opts = {
      -- print the capture group name when executing next/previous
      debug = true,
      -- disable key bindings
      -- key_bindings_disabled = true,
      key_bindings = {
        next = "<Tab>",
        previous = "<S-Tab>",
      },
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
          offsets = {
            string_start_capture = 1,
          },
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
}
