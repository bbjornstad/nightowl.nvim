require('null-ls').setup({
    sources = {
        require('null-ls').builtins.formatting.yapf,
        require('null-ls').builtins.formatting.yamlfmt,
        require('null-ls').builtins.formatting.prettierd,
        require('null-ls').builtins.diagnostics.sqlfluff,
        require('null-ls').builtins.diagnostics.vint,
        require('null-ls').builtins.diagnostics.shellcheck,
        require('null-ls').builtins.diagnostics.commitlint,
    }
})
