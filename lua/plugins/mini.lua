local opts = { version = false, lazy = false, event = "VeryLazy" }

testing = {
  { "echasnovski/mini.surround", version = false, lazy = false },
  { "echasnovski/mini.jump", version = false, lazy = false },
  { "echasnovski/mini.bracketed", version = false, lazy = false },
  { "echasnovski/mini.align", version = false, lazy = false },
  { "echasnovski/mini.comment", version = false, lazy = false },
  { "echasnovski/mini.sessions", version = false, lazy = false },
}

return {
  { "echasnovski/mini.surround", unpack(opts) },
  { "echasnovski/mini.jump", unpack(opts) },
  { "echasnovski/mini.bracketed", unpack(opts) },
  { "echasnovski/mini.align", unpack(opts) },
  { "echasnovski/mini.comment", unpack(opts) },
  { "echasnovski/mini.sessions", unpack(opts) },
}
