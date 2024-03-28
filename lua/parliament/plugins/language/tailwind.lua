return {
  {
    "luckasRanarison/tailwind-tools.nvim",
    ft = { "tailwind", "css" },
    opts = {
      document_color = {
        enabled = true, -- can be toggled by commands
        kind = "inline", -- "inline" | "foreground" | "background"
        inline_symbol = "󰝤 ", -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        symbol = "󱏿", -- only a single character is allowed
        highlight = { -- extmark highlight options, see :h 'highlight'
          fg = "#38BDF8",
        },
      },
    },
    config = function(_, opts)
      require("tailwind-tools").setup(opts)
    end,
    cmd = {
      "TailwindConcealEnable",
      "TailwindConcealToggle",
      "TailwindColorEnable",
      "TailwindColorToggle",
      "TailwindSort",
      "TailwindSortSelection",
    },
    keys = {},
  },
}
