local env = require("environment.ui")
local kenv = require("environment.keys")
local key_repl = kenv.repl
local mopts = require("funsak.table").mopts

local mapn = function(lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap("n", lhs, rhs, opts)
end

return {
  {
    "vlime/vlime",
    ft = { "lisp" },
    config = function(plugin)
      vim.opt.rtp:append((plugin.dir .. "vim/"))
    end,
    keys = {
      {
        key_repl.vlime,
        "<CMD>!sbcl --load <CR>",
        mode = "n",
        desc = "lisp=> start vlime",
      },
    },
  },
  {
    "michaelb/sniprun",
    build = "sh ./install.sh",
    config = true,
    -- opts = {},
    -- event = "VeryLazy",
    keys = {
      {
        key_repl.sniprun.line,
        "<Plug>SnipRun",
        mode = { "n" },
        silent = true,
        desc = "repl.snip=> line sniprun",
      },
      {
        key_repl.sniprun.operator,
        "<Plug>SnipRunOperator",
        mode = { "n" },
        silent = true,
        desc = "repl.snip=> operator sniprun",
      },
      {
        key_repl.sniprun.run,
        "<Plug>SnipRun",
        mode = { "v" },
        silent = true,
        desc = "repl.snip=> sniprun",
      },
      {
        key_repl.sniprun.info,
        "<Plug>SnipInfo",
        mode = { "n" },
        silent = true,
        desc = "repl.snip=> sniprun info",
      },
      {
        key_repl.sniprun.close,
        "<Plug>SnipClose",
        mode = { "n" },
        desc = "repl.snip=> close sniprun",
      },
      {
        key_repl.sniprun.live,
        "<Plug>SnipLive",
        mode = { "n" },
        silent = true,
        desc = "repl.snip=> sniprun live mode",
      },
    },
  },
  {
    "Vigemus/iron.nvim",
    tag = "v3.0",
    module = "iron.core",
    opts = {
      config = {
        repl_open_cmd = ":lua require('iron.view').split.vertical.botright(50)",
        scratch_repl = true,
        repl_definition = { sh = { command = { "zsh" } } },
      },
      keymaps = {},
    },
    keys = {
      {
        key_repl.iron.filetype,
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.repl_here(ft)
        end,
        mode = "n",
        desc = "repl.iron=> open ft repl",
      },
      {
        key_repl.iron.restart,
        function()
          local core = require("iron.core")
          core.repl_restart()
        end,
        mode = "n",
        desc = "repl.iron=> restart repl",
      },
      {
        key_repl.iron.focus,
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.focus_on(ft)
        end,
        mode = "n",
        desc = "repl.iron=> focus on repl",
      },
      {
        key_repl.iron.hide,
        function()
          local core = require("iron.core")
          local ft = vim.bo.filetype
          core.close_repl(ft)
        end,
        mode = "n",
        desc = "repl.iron=> hide repl",
      },
    },
  },
  {
    "quarto-dev/quarto-nvim",
    opts = {
      debug = true,
      lspFeatures = {
        enabled = true,
        languages = { "r", "python", "julia", "bash", "rust", "haskell", "lua" },
        chunks = "curly",
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
          completion = {
            enabled = true,
          },
        },
        keymap = {
          hover = "K",
          definition = "gd",
          rename = "<leader>cr",
          references = "gr",
        },
      },
    },
    dependencies = {
      {
        "jmbuhr/otter.nvim",
        dependencies = {
          "neovim/nvim-lspconfig",
        },
        event = { "LspAttach" },
        ft = { "quarto", "qmd", "markdown", "rmd", "norg", "org" },
        opts = {
          lsp = {
            hover = {
              border = env.borders.main,
            },
          },
        },
        config = function(_, opts)
          require("otter").setup(opts)
        end,
      },
      "hrsh7th/nvim-cmp",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "qmd" },
    config = function(_, opts)
      local otter = require("otter")
      mapn(
        "gd",
        otter.ask_definition,
        { desc = "repl.otter=> ask for item definition", silent = true }
      )
      mapn(
        "gK",
        otter.ask_hover,
        { desc = "repl.otter=> ask for item hover", silent = true }
      )
      otter.activate({
        "r",
        "python",
        "lua",
        "julia",
        "rust",
        "haskell",
        "zig",
        "typst",
        "json",
        "lisp",
        "scala",
        "lean",
        "clojure",
      }, true)
    end,
  },
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    cmd = {
      "MoltenInit",
      "MoltenDeinit",
      "MoltenEvaluateOperator",
      "MoltenEvaluateLine",
      "MoltenEvaluateVisual",
      "MoltenReevaluateCell",
      "MoltenDelete",
      "MoltenShowOutput",
      "MoltenHideOutput",
      "MoltenInterrupt",
      "MoltenRestart",
      "MoltenSave",
      "MoltenInterrupt",
    },
    init = function()
      vim.g.molten_auto_open_output = false
      vim.g.molten_copy_output = false
      vim.g.molten_image_provider = "image_nvim"
      vim.g.molten_output_crop_border = true
      vim.g.molten_output_show_more = true
      vim.g.molten_output_virt_lines = true
      vim.g.molten_output_win_border = env.borders.main
      vim.g.molten_output_win_cover_gutter = true
      vim.g.molten_use_border_highlights = true
      vim.g.molten_wrap_output = true
    end,
    keys = {
      {
        key_repl.molten.evaluate.line,
        "<CMD>MoltenEvaluateLine<CR>",
        mode = "n",
        desc = "repl.molten=> evaluate line",
      },
      {
        key_repl.molten.evaluate.visual,
        "<CMD>MoltenEvaluateVisual<CR>",
        mode = "x",
        desc = "repl.molten=> evaluate",
      },
      {
        key_repl.molten.evaluate.cell,
        "<CMD>MoltenReevaluateCell<CR>",
        mode = "n",
        desc = "repl.molten=> evaluate cell",
      },
      {
        key_repl.molten.delete,
        "<CMD>MoltenDelete<CR>",
        mode = "n",
        desc = "repl.molten=> delete",
      },
      {
        key_repl.molten.show,
        "<CMD>MoltenShowOutput<CR>",
        mode = "n",
        desc = "repl.molten=> show output",
      },
    },
  },
  {
    "milanglacier/yarepl.nvim",
    config = function(_, opts)
      require("yarepl").setup(opts)
    end,
    opts = function(_, opts)
      opts.buflisted = opts.buflisted or true
      opts.scratch = opts.scratch or true
      opts.ft = opts.ft or "yarepl"
      opts.metas = mopts({
        aichat = {
          cmd = "aichat",
          formatter = require("yarepl").formatter.bracketed_pasting,
        },
        radian = {
          cmd = "radian",
          formatter = require("yarepl").formatter.bracketed_pasting,
        },
        ipython = {
          cmd = "ipython",
          formatter = require("yarepl").formatter.bracketed_pasting,
        },
        python = {
          cmd = "python",
          formatter = require("yarepl").formatter.trim_empty_lines,
        },
        R = {
          cmd = "R",
          formatter = require("yarepl").formatter.trim_empty_lines,
        },
        bash = {
          cmd = "bash",
          formatter = require("yarepl").formatter.trim_empty_lines,
        },
        zsh = {
          cmd = "zsh",
          formatter = require("yarepl").formatter.bracketed_pasting,
        },
      }, opts.metas or {})
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "stevearc/dressing.nvim",
    },
    keys = {
      {
        key_repl.yarepl.start,
        "<CMD>REPLStart<CR>",
        mode = "n",
        desc = "repl.ya=> start [menu]",
      },
      {
        key_repl.yarepl.attach_buffer,
        "<CMD>REPLAttachBufferToREPL<CR>",
        mode = "n",
        desc = "repl.ya=> attach current",
      },
      {
        key_repl.yarepl.detach_buffer,
        "<CMD>REPLDetachBufferToREPL<CR>",
        mode = "n",
        desc = "repl.ya=> detach current",
      },
      {
        key_repl.yarepl.cleanup,
        "<CMD>REPLCleanup<CR>",
        mode = "n",
        desc = "repl.ya=> cleanup",
      },
      {
        key_repl.yarepl.focus,
        "<CMD>REPLFocus<CR>",
        mode = "n",
        desc = "repl.ya=> focus",
      },
      {
        key_repl.yarepl.hide,
        "<CMD>REPLHide<CR>",
        mode = "n",
        desc = "repl.ya=> hide",
      },
      {
        key_repl.yarepl.hide_or_focus,
        "<CMD>REPLHideOrFocus<CR>",
        mode = "n",
        desc = "repl.ya=> hide or focus",
      },
      {
        key_repl.yarepl.close,
        "<CMD>REPLClose<CR>",
        mode = "n",
        desc = "repl.ya=> close",
      },
      {
        key_repl.yarepl.swap,
        "<CMD>REPLSwap<CR>",
        mode = "n",
        desc = "repl.ya=> swap",
      },
      {
        key_repl.yarepl.send_visual,
        "<CMD>REPLSendVisual<CR>",
        mode = "n",
        desc = "repl.ya=> send visual",
      },
      {
        key_repl.yarepl.send_line,
        "<CMD>REPLSendLine<CR>",
        mode = "n",
        desc = "repl.ya=> send line",
      },
      {
        key_repl.yarepl.send_operator,
        "<CMD>REPLSendOperator<CR>",
        mode = "n",
        desc = "repl.ya=> send operator",
      },
      {
        key_repl.yarepl.exec,
        "<CMD>REPLExec<CR>",
        mode = "n",
        desc = "repl.ya=> exec",
      },
    },
  },
}
