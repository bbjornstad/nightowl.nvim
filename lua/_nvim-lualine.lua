local mod = {}

local navic = require("nvim-navic")

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = {left = "", right = ""},
        section_separators = {left = "", right = ""},
        disabled_filetypes = {
            statusline = {"NvimTree", "vista"},
            winbar = {"NvimTree", "vista"}
        },
        ignore_focus = {"NvimTree", "vista"},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {statusline = 500, tabline = 500, winbar = 500}
    },
    sections = {
        lualine_a = {"mode"},
        lualine_b = {{"b:gitsigns_head", icon = ""}, "diff", "diagnostics"},
        lualine_c = {"filename"},
        lualine_x = {require("lsp-status").status(), require('pomodoro').statusline, require('orgmode').statusline},
        lualine_y = {"progress"},
        lualine_z = {"location"}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {require('pomodoro').statusline, require('orgmode').statusline}
    },
    tabline = {
        lualine_a = {{"os.date('%a: %Y-%m-%d')"}},
        lualine_b = {"filename"},
        lualine_c = {},
        lualine_x = {"searchcount"},
        lualine_y = {"encoding", "fileformat", "filetype"},
        lualine_z = {"filesize"}
    },
    inactive_tabline = {
        lualine_a = {},
        lualine_b = {"filename"},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {"filesize"}
    },
    winbar = {
        lualine_a = {},
        lualine_b = {{navic.get_location, cond = navic.is_available}},
        lualine_c = {},
        lualine_x = {require("lsp-status").status},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{navic.get_location, cond = navic.is_available}},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {"quickfix", "nerdtree", "fzf", "man"}
})

return mod
