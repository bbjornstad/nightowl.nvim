require('nvim-treesitter.configs').setup {
    ensure_installed = { 
        'bash',
        'python',
        'c',
        'cpp',
        'rust',
        'lua',
        'comment',
        'help',
        'json',
        'latex',
        'norg',
        'org',
        'markdown',
        'make',
        'regex',
        'sql',
        'toml',
        'vim',
        'yaml',
    },
    auto_install = true,
    indent = { 
        enable = true,
    },
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
    }
}
