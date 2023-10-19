local key_preview = require("environment.keys").tool.preview

return {
  {
    "kaarmu/typst.vim",
    ft = { "typst" },
    keys = {
      {
        key_preview,
        "<CMD>TypstWatch<CR>",
        mode = "n",
        desc = "typst=> watch/view PDF",
      },
    },
  },
  {
    "MrPicklePinosaur/typst-conceal.vim",
    ft = { "typst" },
  },
}
