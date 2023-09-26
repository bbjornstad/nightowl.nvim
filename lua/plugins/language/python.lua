local key_repl = require("environment.keys").stems.base.repl
local key_jupyter = key_repl .. "j"
local key_fstring_toggle = "<leader>c"
local def = require('uutils.lazy').implang

return {
  def({"python", "py"}, "black", {"ruff", "pycodestyle", "pydocstyle"}),
  { "jmcantrell/vim-virtualenv", ft = { "python" } },
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
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
    build = [[:UpdateRemotePlugins]],
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
  {
    "roobert/f-string-toggle.nvim",
    config = function(_, opts)
      require("f-string-toggle").setup(opts)
    end,
    ft = "python",
    opts = {
      key_binding = key_fstring_toggle,
    },
  },
  {
    "numirias/semshi",
    build = ":UpdateRemotePlugins",
    ft = "python",
  },
}