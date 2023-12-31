local key_jupyter = require("environment.keys").repl.jupyter
local key_fstring_toggle =
  require("environment.keys").lang.python.fstring_toggle
local lsp = require("funsak.lsp")

return {
  lsp.server("jedi_language_server", { server = {} }),
  lsp.linters(
    lsp.per_ft(
      { "ruff", "flake8", "mypy", "pydocstyle", "vulture" },
      { "python", "py", "jupyter", "ipynb" }
    )
  ),
  lsp.formatters(lsp.per_ft({
    "black",
    "isort",
    "ruff-fix",
    "ruff-format",
    "autoflake",
    "autopep8",
    "docformatter",
    "pyment",
    "usort",
  }, { "python", "py", "jupyter", "ipynb" })),
  {
    "jmcantrell/vim-virtualenv",
    ft = { "python" },
  },
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
        key_jupyter.attach,
        "<CMD>JupyterAttach<CR>",
        mode = { "n" },
        desc = "repl.py=> attach jupyter kernel",
      },
      {
        key_jupyter.detach,
        "<CMD>JupyterDetach<CR>",
        mode = { "n" },
        desc = "repl.py=> detach jupyter kernel",
      },
      {
        key_jupyter.execute,
        "<CMD>JupyterExecute<CR>",
        mode = { "n", "v" },
        desc = "repl.py=> jupyter execute",
      },
      {
        key_jupyter.inspect,
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
