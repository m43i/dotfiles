return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
		},
	},
	config = function()
		local parsers = { "vimdoc", "javascript", "typescript", "php", "c", "lua", "rust", "json" }
		local treesitter = require("nvim-treesitter")

		treesitter.setup()

		local installed = treesitter.get_installed()
		local missing = vim.iter(parsers)
			:filter(function(parser)
				return not vim.tbl_contains(installed, parser)
			end)
			:totable()

		if #missing > 0 then
			treesitter.install(missing)
		end

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
				if not lang or not vim.tbl_contains(treesitter.get_installed("parsers"), lang) then
					return
				end

				vim.treesitter.start(args.buf, lang)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
