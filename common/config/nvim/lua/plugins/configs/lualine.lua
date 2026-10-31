local get_lsp_client = function()
    local buf_ft = vim.bo.filetype
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        return ""
    end
    local lsps = ""
    for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            if lsps == "" then
                lsps = client.name
            else
                if not string.find(lsps, client.name) then
                    lsps = lsps .. ", " .. client.name
                end
            end
        end
    end
    if lsps == "" then
        return ""
    else
        return lsps
    end
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
