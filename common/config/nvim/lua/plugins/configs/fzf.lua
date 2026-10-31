local fzf_lua = require("fzf-lua")

-- fd を使う設定を追加
fzf_lua.setup({
    files = {
        -- fdコマンドを使って隠しファイルも検索、.git は除外
        cmd = "fd --type f --hidden --follow --exclude .git",
    },
})

-- vim.ui.select (LSP の code action の gra など) も fzf で選ぶ
fzf_lua.register_ui_select()

-- The reason I added  'opts' as a paraameter is so you can
-- call this function with your own parameters / customizations
-- for example: 'git_files_cwd_aware({ cwd = <another git repo> })'
local function git_files_cwd_aware(opts)
    opts = opts or {}
    -- git_root() will warn us if we're not inside a git repo
    -- so we don't have to add another warning here, if
    -- you want to avoid the error message change it to:
    -- local git_root = fzf_lua.path.git_root(opts, true)
    local git_root = fzf_lua.path.git_root(opts)
    if not git_root then
        return
    end
    local relative = fzf_lua.path.relative(vim.uv.cwd(), git_root)
    opts.fzf_opts = { ["--query"] = git_root ~= relative and relative .. "/" or nil }
    return fzf_lua.git_files(opts)
end

-- buffers and files
vim.keymap.set("n", "<leader>e", fzf_lua.files)
vim.keymap.set("n", "<leader>b", fzf_lua.buffers)
vim.keymap.set("n", "<Leader>q", fzf_lua.quickfix)
vim.keymap.set("n", "<Leader>o", fzf_lua.oldfiles)

-- search
vim.keymap.set("n", "<Leader>fgg", fzf_lua.live_grep)

-- git
vim.keymap.set("n", "<Leader>fga", fzf_lua.git_files)
vim.keymap.set("n", "<Leader>fgf", git_files_cwd_aware)
vim.keymap.set("n", "<Leader>fgl", fzf_lua.git_bcommits)
vim.keymap.set("n", "<Leader>fgc", fzf_lua.git_commits)
vim.keymap.set("n", "<Leader>fgs", fzf_lua.git_status)
vim.keymap.set("n", "<Leader>fgb", fzf_lua.git_branches)

-- lsp/diagnostics
vim.keymap.set("n", "<Leader>fla", fzf_lua.lsp_code_actions)
vim.keymap.set("n", "<Leader>fld", fzf_lua.lsp_document_diagnostics)
vim.keymap.set("n", "<Leader>flw", fzf_lua.lsp_workspace_diagnostics)
vim.keymap.set("n", "<Leader>fls", fzf_lua.lsp_live_workspace_symbols)

vim.keymap.set("n", "<Leader>fch", fzf_lua.command_history)
vim.keymap.set("n", "<Leader>fx", fzf_lua.commands)
