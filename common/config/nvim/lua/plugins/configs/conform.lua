require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		html = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		typescript = { "prettier" },
		vue = { "prettier" },
		php = { "php_cs_fixer" },
		go = { "goimports" },
		zig = { "zigfmt" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})
