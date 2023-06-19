return {
  { "echasnovski/mini.colors", version = false },
  { "echasnovski/mini.surround", event = "VeryLazy", version = false },
  { "echasnovski/mini.bracketed", event = "VeryLazy", version = false },
  { "echasnovski/mini.align", event = "VeryLazy", version = false },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      custom_commentstring = function()
        return require("ts_context_commentstring.internal").calculate_commentstring()
          or vim.bo.commentstring
      end,
      start_of_line = true,
      pad_comment_parts = true,
      ignore_blank_line = false,
    },
    version = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.context_commentstring = vim.tbl_extend("force", {
        enable = true,
        enable_autocmd = false,
      }, opts.context_commentstring or {})
    end,
  },
  { "echasnovski/mini.sessions", event = "VeryLazy", version = false },
  {
    "ggandor/flit.nvim",
    enabled = false,
  },
  {
    "echasnovski/mini.jump",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        repeat_jump = "",
      },
    },
  },
  {
    "echasnovski/mini.jump2d",
    version = false,
    event = "VeryLazy",
    opts = {
      view = {
        dim = false,
        n_steps_ahead = 3,
      },
      allowed_windows = {
        current = true,
        not_current = false,
      },
      mappings = {
        start_jumping = "'",
      },
    },
  },
}
