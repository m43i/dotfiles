return {
	"alexghergh/nvim-tmux-navigation",
	keys = {
		{
			"<C-h>",
			"<CMD>lua require('nvim-tmux-navigation').NvimTmuxNavigateLeft()<CR>",
			desc = "Tmux Left",
			mode = { "n", "v", "i", "t" },
		},
		{
			"<C-j>",
			"<CMD>lua require('nvim-tmux-navigation').NvimTmuxNavigateDown()<CR>",
			desc = "Tmux Down",
			mode = { "n", "v", "i", "t" },
		},
		{
			"<C-k>",
			"<CMD>lua require('nvim-tmux-navigation').NvimTmuxNavigateUp()<CR>",
			desc = "Tmux Up",
			mode = { "n", "v", "i", "t" },
		},
		{
			"<C-l>",
			"<CMD>lua require('nvim-tmux-navigation').NvimTmuxNavigateRight()<CR>",
			desc = "Tmux Right",
			mode = { "n", "v", "i", "t" },
		},
	},
	config = true,
}
