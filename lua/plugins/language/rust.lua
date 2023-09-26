local env = require("environment.ui")
local def = require('uutils.lazy').lang
local merger = require('uutils.merger')

return {
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = function()
      local masoner = merger("lspconfig-zeromason", "mason-lspconfig")
      masoner({
        handlers = {
          rust = require('lsp-zero').noop
        }
      })
      def({ "rust", "rs" }, "rustfmt")
      return {
        tools = {
          inlay_hints = {
            auto = true,
            max_len_align = true,
          },
          hover_actions = {
            border = env.borders.main,
            auto_focus = true,
          },
          executor = {
            require("rust-tools.executors").toggleterm,
          },
        },
      }
    end
  },
}
