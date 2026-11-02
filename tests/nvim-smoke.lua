-- nvim が設定を読み込んでエラーなく起動できるかの確認。
-- 使い方: nvim --headless -c "luafile tests/nvim-smoke.lua"
-- 失敗すると cquit 1 で終わる。プラグインの取得 (Lazy! sync) は別に済ませておく。
local failures = {}
local function fail(msg)
    table.insert(failures, msg)
end

-- VeryLazy まで走らせて、遅延読み込みの spec も動かす
vim.wait(3000, function()
    return false
end, 100)

-- 設定の読み込み中に起きた Lua エラーは v:errmsg に残る。
-- mason がツール (prettier など) を入れられなかった通知は、取得先の都合 (CI には npm が無い) なので除外する
if vim.v.errmsg ~= "" and not vim.v.errmsg:match("^%[mason") then
    fail("v:errmsg: " .. vim.v.errmsg)
end

-- 起動時に読まれるはずのプラグイン
for _, mod in ipairs({ "conform", "cmp", "luasnip", "lualine", "fzf-lua", "lspconfig", "mason", "nvim-treesitter" }) do
    local ok, err = pcall(require, mod)
    if not ok then
        fail("require(" .. mod .. "): " .. tostring(err):gsub("\n.*", ""))
    end
end

-- LSP 設定が組み立てられていて、使うサーバーの定義が引ける
for _, name in ipairs({ "gopls", "lua_ls", "zls", "ts_ls", "pyright" }) do
    if not vim.lsp.config[name] then
        fail("vim.lsp.config." .. name .. " が無い")
    end
end

-- 主要なキーマップ
local function mapped(lhs, mode)
    return next(vim.fn.maparg(lhs, mode, false, true)) ~= nil
end
for _, key in ipairs({ "<Space>e", "<Space>fgg", "<Space>Y", "<Esc><Esc>" }) do
    if not mapped(key, "n") then
        fail("ノーマルモードの " .. key .. " が割り当てられていない")
    end
end

if #failures > 0 then
    print("nvim smoke test: FAIL")
    for _, f in ipairs(failures) do
        print("  - " .. f)
    end
    vim.cmd("cquit 1")
else
    print("nvim smoke test: ok")
    vim.cmd("qa!")
end
