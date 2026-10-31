local options = {
    clipboard = 'unnamed,unnamedplus', -- Copy paste between vim and everything else
    wrap = false, -- Display long lines as just one line
    updatetime = 300, -- CursorHold (LSP のハイライト・診断のポップアップ) までの待ち
    completeopt = 'menu,menuone,noselect',
    showmode = false, -- We don't need to see things like -- INSERT -- anymore
    backup = false,
    writebackup = false,
    pumheight = 10, -- Makes popup menu smaller
    cmdheight = 2, -- More space for displaying messages
    mouse = 'a', -- Enable your mouse
    splitbelow = true, -- Horizontal splits will automatically be below
    termguicolors = true,
    splitright = true, -- Vertical splits will automatically be to the right
    conceallevel = 0, -- So that I can see `` in markdown files
    ts = 4, -- Insert 4 spaces for a tab
    expandtab = true, -- Converts tabs to spaces
    smartindent = true, -- Makes indenting smart
    cursorline = true, -- Enable highlighting of the current line
    showtabline = 2, -- Always show tabs
    foldlevel = 99, -- Open all folds by default (treesitter folding stays enabled)
}
for k, v in pairs(options) do
    vim.opt[k] = v
end

local cmd = vim.cmd

cmd 'filetype plugin indent on'

-- ハイフン区切りを 1 単語として扱うのは、識別子にハイフンが入る言語だけ。
-- 全体に効かせると Go や Zig の `a-b` (引き算) が 1 単語になり、w / e / * が引っかかる。
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "css", "scss", "html", "vue", "yaml" },
    callback = function()
        vim.opt_local.iskeyword:append("-")
    end,
})
cmd 'set shortmess+=c' -- Don't pass messages to |ins-completion-menu|.
cmd 'set sw=4' -- Change the number of space characters inserted for indentation
--cmd 'set whichwrap+=<,>,[,],h,l'

-- GUI のクリップボードが無い機械 (ssh や WezTerm の SSHMUX で入る devhost) では、
-- OSC 52 でクリップボードを手元の wezterm に飛ばす。SSHMUX のペインには SSH_TTY が無いので、それでは判定しない。
-- wezterm は OSC 52 paste クエリには応答しないため、paste はローカルレジスタを返す。
local has_gui_clipboard = vim.fn.has("mac") == 1 or vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil
if vim.env.SSH_TTY or not has_gui_clipboard then
    local function paste()
        return {
            vim.split(vim.fn.getreg(''), '\n'),
            vim.fn.getregtype(''),
        }
    end
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            ['+'] = paste,
            ['*'] = paste,
        },
    }
end
