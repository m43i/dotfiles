return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "BufReadPost", "InsertLeave" },
	opts = {
		linters_by_ft = {
			-- Use the "*" filetype to run linters on all filetypes.
			-- ['*'] = { 'global linter' },
			-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
			-- ['_'] = { 'fallback linter' },
			-- ["*"] = { "typos" },
		},
	},
    config = function(_, opts)
        local lint = require("lint")

        lint.linters_by_ft = opts.linters_by_ft
    end,
}
