return {
	"zbirenbaum/copilot.lua",
	dependencies = {
		"copilotlsp-nvim/copilot-lsp",
	},
	config = function()
		require("copilot").setup({
			panel = { enable = false },
			suggestion = { enabled = false },
			nes = {
                enable = false,
				auto_trigger = false,
				keymap = {
					accept = "<Tab>",
					dismiss = "<Esc>",
				},
			},
		})

		-- Hide copilot suggestions when blink menu opens
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuOpen",
			callback = function()
				vim.b.copilot_suggestion_hidden = true
			end,
		})

		-- Show copilot suggestions when blink menu closes
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuClose",
			callback = function()
				vim.b.copilot_suggestion_hidden = false
			end,
		})
	end,
}
