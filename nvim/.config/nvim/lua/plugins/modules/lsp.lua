return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "mason-org/mason.nvim", config = true, build = ":MasonUpdate" },
		"mason-org/mason-lspconfig.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"folke/neodev.nvim",
		{ "b0o/schemastore.nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "L3MON4D3/LuaSnip" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "onsails/lspkind.nvim" },
	},
	config = function()
		local cmp = require("cmp")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		local lspkind = require("lspkind")
		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["Tab"] = nil,
				["S-Tab"] = nil,
			}),
			sources = {
				{ name = "nvim_lsp" },
				{ name = "supermaven" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			},
			formatting = {
				fields = { "abbr", "kind", "menu" },
				expandable_indicator = true,
				format = lspkind.cmp_format({
					mode = "symbol_text",
					menu = {
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
						nvim_lua = "[Lua]",
						latex_symbols = "[Latex]",
					},
					maxwidth = 50,
					ellipsis_char = "...",
					show_labelDetails = true,
				}),
			},
		})

		lspkind.init({
			symbol_map = {
				Supermaven = "",
			},
		})
		vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })

		require("lspconfig.ui.windows").default_options.border = "single"
		require("neodev").setup()

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_nvim_lsp.default_capabilities()
		)

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
            root_pattern = { 'package.json', 'tsconfig.json' },
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
        vim.lsp.config("clangd", {
			capabilities = capabilities,
			on_attach = require("config.lsp.on_attach").on_attach,
			filetypes = { "c", "ino", "cpp", "hpp", "h" },
		})
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
