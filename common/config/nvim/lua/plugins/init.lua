local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
	-- Colorscheme
	{
		"bluz71/vim-nightfly-colors",
		config = function()
			vim.cmd([[colorscheme nightfly]])
		end,
		lazy = false,
		priority = 1000,
	},
	-- lsp (設定は lua/lsp。mason はフォーマッタと、pacman に無いサーバー用)
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim" },
		},
		config = function()
			-- mason の bin を PATH に足すので、サーバーを有効にする前に呼ぶ
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
			require("lsp").setup()
		end,
	},

	-- 自動補完
	{
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.configs.cmp")
		end,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
		},
	},

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	{ "saadparwaiz1/cmp_luasnip" },

	-- status-line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.configs.lualine")
		end,
	},

	-- Treesitter (main branch)
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({})

			local langs = {
				"lua",
				"vim",
				"vimdoc",
				"markdown",
				"markdown_inline",
				"bash",
				"json",
				"yaml",
				"toml",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"go",
				"rust",
				"python",
				"java",
				"php",
			}

			require("nvim-treesitter").install(langs)

			local lang_to_ft = {
				vimdoc = "help",
				bash = "sh",
				tsx = "typescriptreact",
			}

			local fts = {}
			for _, l in ipairs(langs) do
				if l ~= "markdown_inline" then
					table.insert(fts, lang_to_ft[l] or l)
				end
			end

			local highlight_disable = {
				c = true,
				rust = true,
				javascript = true,
				vue = true,
				sql = true,
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = fts,
				callback = function(ev)
					if not highlight_disable[ev.match] then
						pcall(vim.treesitter.start)
					end
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
				end,
			})
		end,
	},

	-- ファイラー
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>y", "<cmd>Yazi<cr>", mode = { "n", "v" }, desc = "Open yazi at the current file" },
			{ "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open yazi at cwd" },
			{ "<leader>Y", "<cmd>Yazi toggle<cr>", desc = "Toggle/resume yazi" },
		},
		opts = {
			open_for_directories = false,
			keymaps = {
				show_help = "<f1>",
			},
		},
	},

	-- formatter
	{
		"stevearc/conform.nvim",
		dependencies = { "zapling/mason-conform.nvim" },
		config = function()
			require("plugins.configs.conform")
			require("mason-conform").setup()
		end,
	},

	-- fzf
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.configs.fzf")
		end,
	},

	-- Git 差分表示
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end
				map("n", "]c", function()
					gs.nav_hunk("next")
				end, "Next hunk")
				map("n", "[c", function()
					gs.nav_hunk("prev")
				end, "Prev hunk")
				map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
				map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
				map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>gb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle blame")
				map("n", "<leader>gd", gs.diffthis, "Diff this")
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
			end,
		},
	},

	-- Markdown プレビュー (:MdKite)。devhost の loopback で待ち受けるので、Mac からは ssh -L 8421:localhost:8421 で見る
	{
		"selimacerbas/mdkite.nvim",
		dependencies = { "selimacerbas/kitehost.nvim" },
		ft = "markdown",
		config = function()
			require("mdkite").setup({
				instance_mode = "takeover",
				port = 8421,
				host = "127.0.0.1",
				open_browser = false,
				hooks = {
					on_start = function(url)
						vim.notify("Preview: " .. url)
					end,
				},
			})
		end,
	},

	-- Claude Code 連携
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>a", nil, desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeSend<cr>",
				mode = "v",
				desc = "Send to Claude",
			},
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		},
	},
})
