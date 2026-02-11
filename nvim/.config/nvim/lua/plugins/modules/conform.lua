return {
	"stevearc/conform.nvim",
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
				javascriptreact = { "oxfmt", "biome", "prettierd", stop_after_first = true },
				typescript = { "oxfmt", "biome", "prettierd", stop_after_first = true },
				typescriptreact = { "oxfmt", "biome", "prettierd", stop_after_first = true },
                json = { "oxfmt", "biome", "prettierd" },
                yaml = { "prettierd" },
				vue = { "oxfmt", "prettierd" },
				svelte = { "prettierd" },
				go = { "goimports", "gofmt" },
				lua = { "stylua" },
                python = { "black" },
				["*"] = { "injected" },
			},
			formatters = {
				biome = {
					condition = function(_, ctx)
                        local find = vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
                        return find ~= nil
					end,
				},
				oxfmt = {
					condition = function(_, ctx)
                        local find = vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }, { path = ctx.filename, upward = true })[1]
                        return find ~= nil
					end,
				},
				prettierd = {
					env = {
						PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/utils/linter-config/.prettierrc.json"),
					},
				},
			},
		})
	end,
}
