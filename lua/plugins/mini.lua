return {
  { "echasnovski/mini.colors", event = "VeryLazy", version = false },
  { "echasnovski/mini.surround", event = "VeryLazy", version = false },
  { "echasnovski/mini.bracketed", event = "VeryLazy", version = false },
  { "echasnovski/mini.align", event = "VeryLazy", version = false },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      -- custom_commentstring = function()
      --   return require("ts_context_commentstring.internal").calculate_commentstring({})
      --     or vim.bo.commentstring
      -- end,
      start_of_line = false,
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
    "echasnovski/mini.bufremove",
    enabled = false,
    event = "VeryLazy",
    version = false,
  },
}
