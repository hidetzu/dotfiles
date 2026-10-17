-- LSP: サーバーの既定値は nvim-lspconfig の lsp/*.lua、上書きは lsp/settings.lua。
-- キーは nvim の既定 (grr / gri / grn / gra / grt / gO / K / <C-s> / ]d / [d / <C-w>d) に乗り、
-- 一覧を出すものだけ fzf-lua に向ける。
local M = {}

-- 使うサーバー (入っていないものは起動しない)
local servers = { "gopls", "lua_ls", "zls", "ts_ls", "pyright" }

-- Floating windows (hover / signature_help / diagnostics) のデフォルト枠線
vim.o.winborder = "rounded"

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
})

local function on_attach(client, bufnr)
    local fzf = require("fzf-lua")
    local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end
    -- 候補が 1 件ならそのまま飛ぶ (fzf-lua の jump1 は既定で有効)
    map("gd", fzf.lsp_definitions, "Definition")
    map("gD", vim.lsp.buf.declaration, "Declaration")
    map("grr", fzf.lsp_references, "References")
    map("gri", fzf.lsp_implementations, "Implementation")
    map("grt", fzf.lsp_typedefs, "Type definition")
    map("gO", fzf.lsp_document_symbols, "Document symbols")

    -- カーソル下と同じ名前をハイライトする
    if client:supports_method("textDocument/documentHighlight") then
        local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    -- Inlay hints (型推論の結果などを行末に出す。<leader>th で切り替え)
    if client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
end

function M.setup()
    for _, group in ipairs({ "LspReferenceRead", "LspReferenceText", "LspReferenceWrite" }) do
        vim.api.nvim_set_hl(0, group, { link = "Visual" })
    end

    vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })
    for name, config in pairs(require("lsp.settings")) do
        vim.lsp.config(name, config)
    end

    local enabled = {}
    for _, name in ipairs(servers) do
        local cmd = vim.lsp.config[name] and vim.lsp.config[name].cmd
        if type(cmd) ~= "table" or vim.fn.executable(cmd[1]) == 1 then
            table.insert(enabled, name)
        end
    end
    vim.lsp.enable(enabled)

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("custom_lsp", { clear = true }),
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client then
                on_attach(client, ev.buf)
            end
        end,
    })

    -- カーソルを止めると、その行の診断をポップアップする
    vim.api.nvim_create_autocmd("CursorHold", {
        group = vim.api.nvim_create_augroup("diagnostic_float", { clear = true }),
        callback = function()
            vim.diagnostic.open_float({
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                source = true,
                prefix = " ",
            })
        end,
    })
end

return M
