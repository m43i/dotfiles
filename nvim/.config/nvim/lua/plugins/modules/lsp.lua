return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "mason-org/mason.nvim", config = true, build = ":MasonUpdate" },
		"mason-org/mason-lspconfig.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"folke/neodev.nvim",
		{ "b0o/schemastore.nvim" },
	},
	config = function()
		require("lspconfig.ui.windows").default_options.border = "single"
		require("neodev").setup()

        local capabilities = vim.lsp.protocol.make_client_capabilities()

		local vue_language_server_path = vim.fn.exepath("vue-language-server") .. "/node_modules/@vue/language-server"
		vim.lsp.config("*", {
			on_attach = require("config.lsp.on_attach").on_attach,
			capabilities = capabilities,
		})
		vim.lsp.config("gopls", {
			on_attach = require("config.lsp.on_attach").on_attach,
			capabilities = capabilities,
			settings = require("config.lsp.servers").gopls,
		})
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			root_pattern = { "package.json", "tsconfig.json" },
			on_attach = require("config.lsp.on_attach").on_attach,
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_language_server_path,
						languages = { "vue" },
					},
				},
			},
			filetypes = (require("config.lsp.servers").ts_ls or {}).filetypes,
		})
		local has_idf = vim.fn.executable("idf.py") == 0
		if has_idf then
			vim.lsp.config("clangd", {
				capabilities = capabilities,
				on_attach = require("config.lsp.on_attach").on_attach,
				filetypes = { "c", "ino", "cpp", "hpp", "h" },
			})
		else
			vim.lsp.config("clangd", {
				capabilities = capabilities,
				on_attach = require("config.lsp.on_attach").on_attach,
				filetypes = { "c", "ino", "cpp", "hpp", "h" },
				cmd = { "/home/malte/.espressif/tools/esp-clang/esp-19.1.2_20250312/esp-clang/bin/clangd" },
			})
		end
		vim.lsp.config("pylsp", {
			capabilities = capabilities,
			on_attach = require("config.lsp.on_attach").on_attach,
			settings = {
				pylsp = {
					plugins = {
						flake8 = {
							enabled = true,
							maxLineLength = 120,
						},
						mypy = {
							enabled = true,
						},
						pycodestyle = {
							enabled = false,
						},
						pyflakes = {
							enabled = false,
						},
					},
				},
			},
		})
		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			on_attach = require("config.lsp.on_attach").on_attach,
			settings = require("config.lsp.servers").lua_ls,
		})

		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		require("mason-lspconfig").setup({
			automatic_installation = false,
			ensure_installed = vim.tbl_keys(require("config.lsp.servers")),
			automatic_enable = true,
		})

		vim.diagnostic.config({
			title = false,
			underline = true,
			virtual_text = true,
			signs = {
				active = true,
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			update_in_insert = false,
			severity_sort = true,
			icons = {
				Error = " ",
				Warn = " ",
				Hint = "󰠠 ",
				Info = " ",
			},
			float = {
				source = "if_many",
				style = "minimal",
				border = "rounded",
				header = "",
				prefix = "",
			},
		})
	end,
}
