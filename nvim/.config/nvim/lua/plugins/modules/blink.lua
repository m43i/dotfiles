return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
	},
	event = "InsertEnter",
	opts = {
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = true,
			},
		},
		sources = {
			default = { "copilot", "lsp", "path", "snippets", "buffer" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},
		keymap = {
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-y>"] = { "accept", "fallback" },
			["<C-Space>"] = { "hide", "fallback" },
			["<C-H>"] = { "show", "fallback" },
		},
	},
}
