local key_repl = require("environment.keys").stems.repl
local key_jupyter = key_repl .. "j"

return {
  { "jmcantrell/vim-virtualenv", ft = { "python" } },
  {
    "mfussenegger/nvim-dap-python",
    config = function(_, opts)
      require("dap-python").setup("~/.virtualenv/debugpy/python")
    end,
  },
  {
    "lkhphuc/jupyter-kernel.nvim",
    opts = {
      inspect = {
        window = {
          max_width = 90,
        },
      },
      timeout = 0.5,
    },
    cmd = { "JupyterAttach", "JupyterInspect", "JupyterExecute" },
    build = pcall(vim.cmd, [[UpdateRemotePlugins]]),
    keys = {
      {
        key_jupyter .. "a",
        "<CMD>JupyterAttach<CR>",
        mode = { "n" },
        desc = "repl.py=> attach jupyter kernel",
      },
      {
        key_jupyter .. "d",
        "<CMD>JupyterDetach<CR>",
        mode = { "n" },
        desc = "repl.py=> detach jupyter kernel",
      },
      {
        key_jupyter .. "x",
        "<CMD>JupyterExecute<CR>",
        mode = { "n", "v" },
        desc = "repl.py=> jupyter execute",
      },
      {
        key_jupyter .. "k",
        "<CMD>JupyterInspect<CR>",
        mode = "n",
        desc = "repl.py=> jupyter inspect",
      },
    },
  },
}
