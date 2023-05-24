local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
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
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "VonHeikemen/lsp-zero.nvim",
    },
    event = "VeryLazy",
    opts = { fold_virt_text_handler = handler },
    init = function()
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldcolumn = "0"
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end, { desc = "ufo:>> open all ultrafolded" })
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end, { desc = "ufo:>> close all ultrafolded" })
      vim.keymap.set(
        "n",
        "zr",
        require("ufo").openFoldsExceptKinds,
        { desc = "ufo:>> close all ultrafolded" }
      )
      vim.keymap.set(
        "n",
        "zm",
        require("ufo").closeFoldsWith,
        { desc = "ufo:>> close all ultrafolded" }
      )
      vim.keymap.set(
        "n",
        "zI",
        require("ufo").inspect,
        { desc = "ufo:>> inspect current buffer" }
      )
      vim.keymap.set("n", "zp", function()
        return require("ufo").peekFoldedLinesUnderCursor(true, true)
      end, { desc = "ufo:>> peek under fold" })
    end,
  },
}
