local plugins = {
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require("configs.conform"),
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
		},
		event = "VeryLazy",
		config = function()
			require("configs.dap")
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
		config = function()
			require("configs.rustacean")
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		event = "VeryLazy",
		config = function()
			require("configs.telescope-ui-select")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"onsails/lspkind.nvim",
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("configs.noice")
		end,
	},
	{
		"folke/trouble.nvim",
		opts = require("configs.trouble"),
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp_document_symbols toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
		},
	},
	{ "wakatime/vim-wakatime", lazy = false },
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
	},
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("configs.colorful-menu")
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "^3.0.0",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	-- {
	-- 	"obsidian-nvim/obsidian.nvim",
	-- 	version = "*",
	-- 	lazy = true,
	-- 	ft = "markdown",
	-- 	dependencies = {
	-- 		-- Required.
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	---@module 'obsidian'
	-- 	---@type obsidian.config.ClientOpts
	-- 	opts = function()
	-- 		return require("configs.obsidian")
	-- 	end,
	-- },
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"xzbdmw/colorful-menu.nvim",
		},
		version = "1.*",
		opts = function()
			return require("configs.blink")
		end,
		opts_extend = { "sources.default" },
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = true,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {},
	},
	-- {
	-- 	"HakonHarnes/img-clip.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {},
	-- 	keys = {
	-- 		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
	-- 	},
	-- },
	-- {
	-- 	"3rd/image.nvim",
	-- 	event = "VeryLazy",
	-- 	build = false,
	-- 	opts = { backend = "kitty", processor = "magick_cli" },
	-- },
	{
		"Olical/conjure",
		ft = { "racket", "scheme" },
		lazy = true,
		init = function() end,
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
	},
	{
		"nickjvandyke/opencode.nvim",
		version = "*", -- Latest stable release
		event = "VeryLazy",
		config = function()
			require("configs.opencodenvim")
		end,
	},
}

return plugins
