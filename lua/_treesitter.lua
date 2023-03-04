require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash", "python", "c", "cpp", "rust", "lua", "comment", "help", "json",
        "latex", "norg", "org", "markdown", "markdown_inline", "make", "regex",
        "sql", "toml", "vim", "yaml", "html", "css"
    },
    auto_install = true,
    indent = {enable = true},
    highlight = {enable = true},
    incremental_selection = {enable = true},
	autotag = {
		enable = true,
	},
})
