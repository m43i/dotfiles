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

		local lspconfig = require("lspconfig")

        local servers = vim.tbl_keys(require("config.lsp.servers"))
        for _, server_name in ipairs(servers) do
				lspconfig[server_name].setup({
					capabilities = capabilities,
					on_attach = require("config.lsp.on_attach").on_attach,
					settings = require("config.lsp.servers")[server_name],
					filetypes = (require("config.lsp.servers")[server_name] or {}).filetypes,
				})
            end
                local vue_language_server_path = vim.fn.exepath("vue-language-server")
                    .. "/node_modules/@vue/language-server"
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
					root_dir = require("lspconfig").util.root_pattern("package.json"),
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
				lspconfig.volar.setup({
					capabilities = capabilities,
					root_dir = require("lspconfig").util.root_pattern("nuxt.config.js"),
					on_attach = require("config.lsp.on_attach").on_attach,
				})
				lspconfig.denols.setup({
					capabilities = capabilities,
					root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc", "import_map.json"),
					on_attach = require("config.lsp.on_attach").on_attach,
				})
				lspconfig.clangd.setup({
					capabilities = capabilities,
					on_attach = require("config.lsp.on_attach").on_attach,
					filetypes = { "c", "ino", "cpp", "hpp", "h" },
				})
				lspconfig.pylsp.setup({
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
			signs = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				source = "if_many",
				style = "minimal",
				border = "rounded",
				header = "",
				prefix = "",
			},
		})

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
	end,
}
