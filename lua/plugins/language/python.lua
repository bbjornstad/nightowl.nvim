local key_jupyter = require("environment.keys").repl.jupyter
local key_fstring_toggle = require("environment.keys").code:leader() .. "f"
local deflang = require("funsak.lazy").language

return {
  unpack(
    deflang(
      { "python", "py" },
      { "black", "isort", "ruff-fix", "ruff-format" },
      { "ruff" }
    )
  ),
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
    "wookayin/semshi",
    build = [[:UpdateRemotePlugins]],
    ft = "python",
  },
}
