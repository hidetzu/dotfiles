local get_lsp_client = function()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, client.name)
    end
    return table.concat(names, ", ")
end

require("lualine").setup({
    options = { theme = "gruvbox" },
    sections = {
        lualine_a = { "filename" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { get_lsp_client },
        lualine_x = {},
        lualine_y = { "encoding", "fileformat", "filetype" },
        lualine_z = { "location" },
    },
})
