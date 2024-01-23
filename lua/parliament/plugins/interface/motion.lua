local env = require("environment.ui")
local opt = require("environment.optional")
local kenv = require("environment.keys").motion.standard
local qenv = require("environment.keys").motion.qortal

return {
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    version = false,
    opts = {
      buffer = { suffix = "b", options = {} },
      comment = { suffix = "c", options = {} },
      conflict = { suffix = "x", options = {} },
      diagnostic = { suffix = "d", options = {} },
      file = { suffix = "f", options = {} },
      indent = { suffix = "i", options = {} },
      jump = { suffix = "j", options = {} },
      location = { suffix = "l", options = {} },
      oldfile = { suffix = "o", options = {} },
      quickfix = { suffix = "q", options = {} },
      treesitter = { suffix = "t", options = {} },
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
    config = true,
    cmd = { "Portal" },
    dependencies = { "cbochs/grapple.nvim", "ThePrimeagen/harpoon" },
  },
  {
    "ThePrimeagen/harpoon",
    opts = {
      save_on_toggle = false,
      save_on_change = true,
      enter_on_sendcmd = false,
      tabline = true,
      tabline_prefix = "󰓩   ",
      tabline_suffix = "╶╶╶╶",
    },
    config = function(_, opts)
      require("harpoon").setup(opts)
      require("telescope").load_extension("harpoon")
    end,
    keys = {
      {
        qenv.harpoon.add_file,
        function()
          require("harpoon.mark").add_file()
        end,
        mode = "n",
        desc = "harpoon=> add file",
      },
      {
        qenv.harpoon.quick_menu,
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        mode = "n",
        desc = "harpoon=> quick menu",
      },
      {
        qenv.harpoon.nav.next,
        function()
          require("harpoon.ui").nav_next()
        end,
        mode = "n",
        desc = "harpoon=> next mark",
      },
      {
        qenv.harpoon.nav.previous,
        function()
          require("harpoon.ui").nav_prev()
        end,
        mode = "n",
        desc = "harpoon=> previous mark",
      },
      {
        qenv.harpoon.nav.file,
        function()
          require("harpoon.ui").nav_file()
        end,
        mode = "n",
        desc = "harpoon=> to file",
      },
      {
        qenv.harpoon.term.to,
        function()
          require("harpoon.term").gotoTerminal()
        end,
        mode = "n",
        desc = "harpoon=> to terminal",
      },
      {
        qenv.harpoon.term.send,
        function()
          require("harpoon.ui").sendCommand()
        end,
        mode = "n",
        desc = "harpoon=> send command",
      },
      {
        kenv.harpoon.term.menu,
        function()
          require("harpoon.cmd-ui").toggle_quick_menu()
        end,
        mode = "n",
        desc = "harpoon=> command quick menu",
      },
      {
        kenv.harpoon.add_file,
        function()
          require("harpoon.mark").add_file()
        end,
        mode = "n",
        desc = "harpoon=> add file",
      },
      {
        kenv.harpoon.quick_menu,
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        mode = "n",
        desc = "harpoon=> quick menu",
      },
      {
        kenv.harpoon.nav.next,
        function()
          require("harpoon.ui").nav_next()
        end,
        mode = "n",
        desc = "harpoon=> next mark",
      },
      {
        kenv.harpoon.nav.previous,
        function()
          require("harpoon.ui").nav_prev()
        end,
        mode = "n",
        desc = "harpoon=> previous mark",
      },
      {
        kenv.harpoon.nav.file,
        function()
          require("harpoon.ui").nav_file()
        end,
        mode = "n",
        desc = "harpoon=> to file",
      },
      {
        kenv.harpoon.term.to,
        function()
          require("harpoon.term").gotoTerminal()
        end,
        mode = "n",
        desc = "harpoon=> to terminal",
      },
      {
        kenv.harpoon.term.send,
        function()
          require("harpoon.ui").sendCommand()
        end,
        mode = "n",
        desc = "harpoon=> send command",
      },
      {
        kenv.harpoon.term.menu,
        function()
          require("harpoon.cmd-ui").toggle_quick_menu()
        end,
        mode = "n",
        desc = "harpoon=> command quick menu",
      },
    },
  },
  {
    "roobert/tabtree.nvim",
    config = function(_, opts)
      require("tabtree").setup(opts)
    end,
    event = "VeryLazy",
    enabled = false, --opt.tabtree,
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
      label = { rainbow = { enabled = true, shade = 7 }, style = "overlay" },
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
        "<BS>",
        function()
          require("flash").treesitter()
        end,
        mode = { "n", "x", "o" },
        desc = "::flash=> jump treesitter",
      },
    },
  },
}
