-- Map leader to space
vim.keymap.set("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- カレントディレクトリを移動する
vim.keymap.set("n", "<leader><leader>", ":<C-u>cd %:h<CR>", { noremap = true })
-- <C-l> はウィンドウ移動に使うので、既定の <C-l> (検索ハイライト消去 + diff 更新 + 再描画) は <Esc><Esc> に持たせる
vim.keymap.set("n", "<ESC><ESC>", function()
    vim.cmd.nohlsearch()
    vim.cmd.diffupdate()
    vim.cmd.redraw({ bang = true })
end, { noremap = true, silent = true })
vim.keymap.set("n", "<c-h>", "<cmd>wincmd h<cr>")
vim.keymap.set("n", "<c-j>", "<cmd>wincmd j<cr>")
vim.keymap.set("n", "<c-k>", "<cmd>wincmd k<cr>")
vim.keymap.set("n", "<c-l>", "<cmd>wincmd l<cr>")

-- Inlay hints toggle (current buffer)
vim.keymap.set("n", "<leader>th", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { silent = true })
