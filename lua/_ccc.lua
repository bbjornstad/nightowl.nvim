local ccc = require("ccc")

ccc.setup({
    win_opts = {relative = "cursor", border = "single", style = "minimal"},
    preserve = true,
    highlighter = {auto_enable = true},
    recognize = {input = true, output = true}
})
