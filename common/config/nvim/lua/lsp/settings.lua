-- サーバーごとの上書き (cmd / filetypes / root_markers は nvim-lspconfig の lsp/*.lua のまま)
-- vim.lsp.config(name, ...) にそのまま渡す
return {
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
                },
            },
        },
    },

    gopls = {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
            },
        },
    },
}
