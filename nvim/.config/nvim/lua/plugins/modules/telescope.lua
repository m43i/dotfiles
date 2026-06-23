return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		if not vim.treesitter.language.ft_to_lang then
			vim.treesitter.language.ft_to_lang = function(filetype)
				return vim.treesitter.language.get_lang(filetype) or filetype
			end
		end

		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "node_modules", ".git" },
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						previewer = false,
						initial_mode = "normal",
						sorting_strategy = "ascending",
						layout_strategy = "horizontal",
						layout_config = {
							horizontal = {
								width = 0.5,
								height = 0.4,
								preview_width = 0.6,
							},
						},
					}),
				},
			},
		})

		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("fzf")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
		vim.keymap.set("n", "<C-p>", builtin.git_files, {})

		vim.keymap.set("n", "<leader>lsd", builtin.lsp_definitions, {})
		vim.keymap.set("n", "<leader>lsi", builtin.lsp_implementations, {})
	end,
}
