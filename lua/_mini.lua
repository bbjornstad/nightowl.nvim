require("mini.surround").setup()
require("mini.jump").setup({
    mappings = {
        forward = "f",
        backward = "F",
        forward_till = "t",
        backward_till = "T",
        repeat_jump = "<F1>"
    }
})
require("mini.bracketed").setup()
require("mini.align").setup()
