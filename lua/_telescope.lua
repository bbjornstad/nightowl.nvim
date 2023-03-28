local keymaps = require("keymappings").scope_mappings
local finalmaps = {}
finalmaps.insert = keymaps
finalmaps.normal = keymaps
finalmaps.nomode = keymaps

local extension_list = {
    -- "fzf",
    "dap", "luasnip", "notify", "env", "heading", "repo", "changes", "menu",
    "recent_files", "software-licenses", "project", "adjacent", "file_browser",
    "zoxide", "lazy", -- "symbols",
    "glyph"
}

require("telescope").setup({
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        layout_strategy = "cursor",
        layout_config = {height = 0.80},
        theme = "ivy",
        mappings = {
            i = finalmaps.insert,
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            n = finalmaps.normal
        }
    },
    pickers = {
        theme = "ivy"
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        theme = "ivy",
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
        -- fzf = {
        --    fuzzy = true, -- false will only do exact matching
        --    override_generic_sorter = true, -- override the generic sorter
        --    override_file_sorter = true, -- override the file sorter
        --    case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        --    -- the default case_mode is "smart_case"
        -- },
        heading = {treesitter = true}
    }
})

local scope = require("telescope")
-- scope.load_extension("fzf")
scope.load_extension("dap")
scope.load_extension("luasnip")
scope.load_extension("notify")
scope.load_extension("env")
scope.load_extension("heading")
scope.load_extension("repo")
scope.load_extension("changes")
scope.load_extension("menu")
scope.load_extension("recent_files")
scope.load_extension("software-licenses")
scope.load_extension("project")
scope.load_extension("adjacent")
scope.load_extension("file_browser")
scope.load_extension("zoxide")
scope.load_extension("lazy")
-- scope.load_extension("symbols")
scope.load_extension("glyph")
