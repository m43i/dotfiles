return {
	"zbirenbaum/copilot.lua",
    dependencies = {
        "copilotlsp-nvim/copilot-lsp",
    },
	config = function()
		require("copilot").setup({
			panel = { enable = false },
			suggestion = { enabled = false },
		})
	end,
}
