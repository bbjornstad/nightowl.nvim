return {
  { "echasnovski/mini.surround", event = "VeryLazy" },
  { "echasnovski/mini.bracketed", event = "VeryLazy" },
  { "echasnovski/mini.align", event = "VeryLazy" },
  { "echasnovski/mini.comment", event = "VeryLazy" },
  { "echasnovski/mini.sessions", event = "VeryLazy" },
  {
    "ggandor/flit.nvim",
    enabled = false,
  },
  {
    "echasnovski/mini.jump",
    event = "VeryLazy",
    opts = {
      mappings = { repeat_jump = "'" },
      delay = {
        highlight = 500,
        idle_stop = 10000000,
      },
    },
  },
}
