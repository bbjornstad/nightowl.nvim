local opts = { version = false, lazy = false, event = "VeryLazy" }

return {
  { "echasnovski/mini.surround", unpack(opts) },
  { "echasnovski/mini.jump", unpack(opts) },
  { "echasnovski/mini.bracketed", unpack(opts) },
  { "echasnovski/mini.align", unpack(opts) },
  { "echasnovski/mini.comment", unpack(opts) },
  { "echasnovski/mini.sessions", unpack(opts) },
}
