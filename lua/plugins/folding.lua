local env = require("environment.ui")
local mopts = require("funsak.table").mopts

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

return { -- add folding range to capabilities
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.capabilities =
        vim.tbl_deep_extend("force", opts.capabilities or {}, {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        })
    end,
  },
  {
    "milisims/foldhue.nvim",
    event = "BufEnter",
    config = function(_, opts)
      require("foldhue").enable()
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "anuvyklack/pretty-fold.nvim",
      { "VonHeikemen/lsp-zero.nvim", optional = true },
    },
    config = function(_, opts)
      require("ufo").setup(opts)
      local ok, zero = pcall(require, "lsp-zero")
      if ok then
        zero.set_server_config({
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
        })
      end
    end,
    event = "BufEnter",
    opts = {
      fold_virt_text_handler = handler,
      preview = {
        win_config = {
          border = env.borders.main,
        },
      },
    },
    init = function()
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldcolumn = "0"
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    end,
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        mode = "n",
        desc = "ufo=> open all ultrafolded",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        mode = "n",
        desc = "ufo=> close all ultrafolded",
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        mode = "n",
        desc = "ufo=> open ultrafolded excepting",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        mode = "n",
        desc = "ufo=> close this ultrafolded",
      },
      {
        "zI",
        function()
          require("ufo").inspect()
        end,
        mode = "n",
        desc = "ufo=> inspect current buffer",
      },
      {
        "zp",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        mode = "n",
        desc = "ufo=> peek under fold",
      },
    },
  },
  {
    "anuvyklack/pretty-fold.nvim",
    config = true,
    event = "BufEnter",
    opts = {
      sections = {
        left = {
          "content",
        },
        right = {
          " ",
          "number_of_folded_lines",
          ": ",
          "percentage",
          " ",
          function(config)
            return config.fill_char:rep(3)
          end,
        },
      },
      fill_char = "🮦",

      remove_fold_markers = true,

      -- Keep the indentation of the content of the fold string.
      keep_indentation = true,

      -- Possible values:
      -- "delete" : Delete all comment signs from the fold string.
      -- "spaces" : Replace all comment signs with equal number of spaces.
      -- false    : Do nothing with comment signs.
      process_comment_signs = "spaces",

      -- Comment signs additional to the value of `&commentstring` option.
      comment_signs = {},

      -- List of patterns that will be removed from content foldtext section.
      stop_words = {
        "@brief%s*", -- (for C++) Remove '@brief' and all spaces after.
      },

      add_close_pattern = true, -- true, 'last_line' or false

      matchup_patterns = {
        { "{", "}" },
        { "%(", ")" }, -- % to escape lua pattern char
        { "%[", "]" }, -- % to escape lua pattern char
      },

      ft_ignore = mopts({ "neorg" }, env.ft_ignore_list, "suppress"),
    },
  },
  {
    "chrisgrieser/nvim-origami",
    config = true,
    opts = {
      keepFoldsAcrossSessions = true,
      pauseFoldsOnSearch = true,
      setupFoldKeymaps = true,
    },
    event = "BufEnter",
  },
  {
    "yaocccc/nvim-foldsign",
    event = "CursorHold",
    config = true,
    opts = {
      offset = 2,
      foldsigns = {
        close = "⌐",
        open = "⌙",
        seps = { "│", "┃" },
      },
    },
  },
}
