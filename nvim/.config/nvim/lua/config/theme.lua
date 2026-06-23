local uv = vim.uv

local M = {}

local omarchy_theme_file = vim.fn.expand("~/.config/omarchy/current/theme.name")
local omarchy_theme_dir = vim.fn.fnamemodify(omarchy_theme_file, ":h")
local supported_themes = {
	kanagawa = "kanagawa",
	miasma = "miasma",
}

local miasma_palette = {
	bg = "#222222",
	dark = "#1c1c1c",
	fg = "#d7c483",
	comment = "#666666",
	green = "#78834b",
	moss = "#5f875f",
	brown = "#685742",
	orange = "#bb7744",
	gold = "#c9a554",
	red = "#b36d43",
}

local watcher
local applied_theme

local function read_omarchy_theme()
	local ok, lines = pcall(vim.fn.readfile, omarchy_theme_file)
	if not ok or not lines or not lines[1] then
		return nil
	end

	local theme = vim.trim(lines[1])
	return theme ~= "" and theme or nil
end

local function resolve_theme(theme_name)
	return supported_themes[theme_name] or "kanagawa"
end

local function setup_kanagawa()
	local ok, kanagawa = pcall(require, "kanagawa")
	if not ok then
		return false
	end

	kanagawa.setup({
		colors = {
			theme = {
				all = {
					ui = {
						bg_gutter = "none",
					},
				},
			},
		},
		overrides = function(colors)
			local theme = colors.theme
			return {
				NormalFloat = { bg = "none" },
				FloatBorder = { bg = "none" },
				FloatTitle = { bg = "none" },

				NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
				LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
				MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
				TelescopeTitle = { fg = theme.ui.special, bold = true },
				TelescopePromptNormal = { bg = theme.ui.bg_p1 },
				TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
				TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
				TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
				TelescopePreviewNormal = { bg = theme.ui.bg_dim },
				TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
				Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
				PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
				PmenuSbar = { bg = theme.ui.bg_m1 },
				PmenuThumb = { bg = theme.ui.bg_p2 },
			}
		end,
	})

	return true
end

local function apply_highlights(theme_name)
	if theme_name ~= "miasma" then
		return
	end

	local set = vim.api.nvim_set_hl
	local p = miasma_palette

	set(0, "NormalFloat", { fg = p.fg, bg = p.dark })
	set(0, "FloatBorder", { fg = p.brown, bg = p.dark })
	set(0, "FloatTitle", { fg = p.gold, bg = p.dark, bold = true })
	set(0, "LazyNormal", { fg = p.fg, bg = p.dark })
	set(0, "LazyError", { fg = p.red, bg = p.dark, bold = true })
	set(0, "LazyWarning", { fg = p.brown, bg = p.dark, bold = true })
	set(0, "LazyInfo", { fg = p.green, bg = p.dark })
	set(0, "LazyReasonRequire", { fg = p.gold })
	set(0, "MasonNormal", { fg = p.fg, bg = p.dark })
	set(0, "MasonBackdrop", { bg = p.bg, blend = 70 })
	set(0, "MasonLink", { fg = p.green, underline = true })
	set(0, "Pmenu", { fg = p.fg, bg = p.dark })
	set(0, "PmenuSel", { fg = p.bg, bg = p.green, bold = true })
	set(0, "PmenuSbar", { bg = p.bg })
	set(0, "PmenuThumb", { bg = p.gold })
	set(0, "InlayHint", { fg = p.comment, bg = p.dark, italic = true })
	set(0, "LspInlayHint", { fg = p.comment, bg = p.dark, italic = true })

	set(0, "BlinkCmpMenu", { fg = p.fg, bg = p.dark })
	set(0, "BlinkCmpMenuBorder", { fg = p.brown, bg = p.dark })
	set(0, "BlinkCmpMenuSelection", { fg = p.bg, bg = p.green, bold = true })
	set(0, "BlinkCmpLabel", { fg = p.fg, bg = p.dark })
	set(0, "BlinkCmpLabelMatch", { fg = p.gold, bold = true })
	set(0, "BlinkCmpLabelDeprecated", { fg = p.comment, strikethrough = true })
	set(0, "BlinkCmpLabelDetail", { fg = p.comment })
	set(0, "BlinkCmpLabelDescription", { fg = p.comment })
	set(0, "BlinkCmpSource", { fg = p.brown })
	set(0, "BlinkCmpKind", { fg = p.green })
	set(0, "BlinkCmpGhostText", { fg = p.comment, italic = true })
	set(0, "BlinkCmpDoc", { fg = p.fg, bg = p.dark })
	set(0, "BlinkCmpDocBorder", { fg = p.brown, bg = p.dark })
	set(0, "BlinkCmpDocSeparator", { fg = p.brown, bg = p.dark })
	set(0, "BlinkCmpDocCursorLine", { bg = p.bg })
	set(0, "BlinkCmpSignatureHelp", { fg = p.fg, bg = p.dark })
	set(0, "BlinkCmpSignatureHelpBorder", { fg = p.brown, bg = p.dark })

	set(0, "TelescopeNormal", { fg = p.fg, bg = p.dark })
	set(0, "TelescopeBorder", { fg = p.brown, bg = p.dark })
	set(0, "TelescopeTitle", { fg = p.green, bg = p.dark, bold = true })
	set(0, "TelescopePromptNormal", { fg = p.fg, bg = p.dark })
	set(0, "TelescopePromptBorder", { fg = p.orange, bg = p.dark })
	set(0, "TelescopePromptTitle", { fg = p.orange, bg = p.dark, bold = true })
	set(0, "TelescopeResultsNormal", { fg = p.fg, bg = p.dark })
	set(0, "TelescopeResultsBorder", { fg = p.brown, bg = p.dark })
	set(0, "TelescopePreviewNormal", { fg = p.fg, bg = p.bg })
	set(0, "TelescopePreviewBorder", { fg = p.gold, bg = p.bg })
	set(0, "TelescopePreviewTitle", { fg = p.gold, bg = p.bg, bold = true })
	set(0, "TelescopeSelection", { fg = p.bg, bg = p.green, bold = true })
	set(0, "TelescopeSelectionCaret", { fg = p.fg, bg = p.green, bold = true })
	set(0, "TelescopeMatching", { fg = p.gold, bold = true })
	set(0, "TelescopeResultsDiffAdd", { fg = p.moss })
	set(0, "TelescopeResultsDiffChange", { fg = p.brown })
	set(0, "TelescopeResultsDiffDelete", { fg = p.red })

	set(0, "NeoTreeNormal", { fg = p.fg, bg = p.dark })
	set(0, "NeoTreeNormalNC", { fg = p.fg, bg = p.dark })
	set(0, "NeoTreeCursorLine", { bg = p.bg })
	set(0, "NeoTreeSignColumn", { bg = p.dark })
	set(0, "NeoTreeEndOfBuffer", { fg = p.dark, bg = p.dark })
	set(0, "NeoTreeWinSeparator", { fg = p.bg, bg = p.dark })
	set(0, "NeoTreeVertSplit", { fg = p.bg, bg = p.dark })
	set(0, "NeoTreeFloatBorder", { fg = p.brown, bg = p.dark })
	set(0, "NeoTreeFloatTitle", { fg = p.gold, bg = p.dark, bold = true })
	set(0, "NeoTreeTitleBar", { fg = p.bg, bg = p.green, bold = true })
	set(0, "NeoTreeRootName", { fg = p.gold, bold = true })
	set(0, "NeoTreeDirectoryName", { fg = p.green })
	set(0, "NeoTreeDirectoryIcon", { fg = p.gold })
	set(0, "NeoTreeFileName", { fg = p.fg })
	set(0, "NeoTreeFileNameOpened", { fg = p.gold })
	set(0, "NeoTreeIndentMarker", { fg = p.comment })
	set(0, "NeoTreeExpander", { fg = p.comment })
	set(0, "NeoTreeDotfile", { fg = p.comment })
	set(0, "NeoTreeHiddenByName", { fg = p.comment })
	set(0, "NeoTreeIgnored", { fg = p.comment })
	set(0, "NeoTreeSymbolicLinkTarget", { fg = p.brown, italic = true })
	set(0, "NeoTreeGitAdded", { fg = p.moss })
	set(0, "NeoTreeGitConflict", { fg = p.orange, italic = true, bold = true })
	set(0, "NeoTreeGitDeleted", { fg = p.red })
	set(0, "NeoTreeGitIgnored", { fg = p.comment })
	set(0, "NeoTreeGitModified", { fg = p.brown })
	set(0, "NeoTreeGitRenamed", { fg = p.brown })
	set(0, "NeoTreeGitStaged", { fg = p.moss })
	set(0, "NeoTreeGitUnstaged", { fg = p.brown })
	set(0, "NeoTreeGitUntracked", { fg = p.moss, italic = true })
	set(0, "NeoTreeModified", { fg = p.gold })
	set(0, "NeoTreeDiagnosticHint", { fg = p.moss })
	set(0, "NeoTreeDiagnosticInfo", { fg = p.green })
	set(0, "NeoTreeDiagnosticWarn", { fg = p.brown })
	set(0, "NeoTreeDiagnosticError", { fg = p.red })

	set(0, "TreesitterContext", { fg = p.fg, bg = p.dark })
	set(0, "TreesitterContextLineNumber", { fg = p.comment, bg = p.dark })
	set(0, "TreesitterContextSeparator", { fg = p.brown, bg = p.dark })
	set(0, "TreesitterContextBottom", { sp = p.brown, underline = true })
	set(0, "TreesitterContextLineNumberBottom", { fg = p.comment, sp = p.brown, underline = true })

	set(0, "DashboardHeader", { fg = p.green })
	set(0, "DashboardFooter", { fg = p.comment, italic = true })
	set(0, "DashboardProjectTitle", { fg = p.gold, bold = true })
	set(0, "DashboardProjectTitleIcon", { fg = p.orange })
	set(0, "DashboardProjectIcon", { fg = p.green })
	set(0, "DashboardMruTitle", { fg = p.gold, bold = true })
	set(0, "DashboardMruIcon", { fg = p.orange })
	set(0, "DashboardFiles", { fg = p.fg })
	set(0, "DashboardShortCut", { fg = p.brown, bold = true })
	set(0, "DashboardShortCutIcon", { fg = p.green })
	set(0, "DashboardIcon", { fg = p.green })
	set(0, "DashboardDesc", { fg = p.fg })
	set(0, "DashboardKey", { fg = p.brown, bold = true })
	set(0, "DashboardPreview", { fg = p.fg, bg = p.bg })

	set(0, "BufferLineFill", { bg = p.dark })
	set(0, "BufferLineBackground", { fg = p.comment, bg = p.dark })
	set(0, "BufferLineBufferVisible", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineBufferSelected", { fg = p.gold, bg = p.bg, bold = true, italic = false })
	set(0, "BufferLineTab", { fg = p.comment, bg = p.dark })
	set(0, "BufferLineTabSelected", { fg = p.gold, bg = p.bg, bold = true })
	set(0, "BufferLineTabClose", { fg = p.red, bg = p.dark })
	set(0, "BufferLineCloseButton", { fg = p.comment, bg = p.dark })
	set(0, "BufferLineCloseButtonVisible", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineCloseButtonSelected", { fg = p.red, bg = p.bg })
	set(0, "BufferLineModified", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineModifiedVisible", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineModifiedSelected", { fg = p.gold, bg = p.bg })
	set(0, "BufferLineDuplicate", { fg = p.comment, bg = p.dark, italic = true })
	set(0, "BufferLineDuplicateVisible", { fg = p.comment, bg = p.dark, italic = true })
	set(0, "BufferLineDuplicateSelected", { fg = p.comment, bg = p.bg, italic = true })
	set(0, "BufferLineSeparator", { fg = p.dark, bg = p.dark })
	set(0, "BufferLineSeparatorVisible", { fg = p.dark, bg = p.dark })
	set(0, "BufferLineSeparatorSelected", { fg = p.dark, bg = p.bg })
	set(0, "BufferLineIndicatorVisible", { fg = p.dark, bg = p.dark })
	set(0, "BufferLineIndicatorSelected", { fg = p.green, bg = p.bg })
	set(0, "BufferLineOffsetSeparator", { fg = p.dark, bg = p.dark })
	set(0, "BufferLinePick", { fg = p.orange, bg = p.dark, bold = true })
	set(0, "BufferLinePickVisible", { fg = p.orange, bg = p.dark, bold = true })
	set(0, "BufferLinePickSelected", { fg = p.orange, bg = p.bg, bold = true })
	set(0, "BufferLineDiagnostic", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineDiagnosticVisible", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineDiagnosticSelected", { fg = p.brown, bg = p.bg })
	set(0, "BufferLineHint", { fg = p.moss, bg = p.dark })
	set(0, "BufferLineHintVisible", { fg = p.moss, bg = p.dark })
	set(0, "BufferLineHintSelected", { fg = p.moss, bg = p.bg })
	set(0, "BufferLineHintDiagnostic", { fg = p.moss, bg = p.dark })
	set(0, "BufferLineHintDiagnosticVisible", { fg = p.moss, bg = p.dark })
	set(0, "BufferLineHintDiagnosticSelected", { fg = p.moss, bg = p.bg })
	set(0, "BufferLineInfo", { fg = p.green, bg = p.dark })
	set(0, "BufferLineInfoVisible", { fg = p.green, bg = p.dark })
	set(0, "BufferLineInfoSelected", { fg = p.green, bg = p.bg })
	set(0, "BufferLineInfoDiagnostic", { fg = p.green, bg = p.dark })
	set(0, "BufferLineInfoDiagnosticVisible", { fg = p.green, bg = p.dark })
	set(0, "BufferLineInfoDiagnosticSelected", { fg = p.green, bg = p.bg })
	set(0, "BufferLineWarning", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineWarningVisible", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineWarningSelected", { fg = p.brown, bg = p.bg })
	set(0, "BufferLineWarningDiagnostic", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineWarningDiagnosticVisible", { fg = p.brown, bg = p.dark })
	set(0, "BufferLineWarningDiagnosticSelected", { fg = p.brown, bg = p.bg })
	set(0, "BufferLineError", { fg = p.red, bg = p.dark })
	set(0, "BufferLineErrorVisible", { fg = p.red, bg = p.dark })
	set(0, "BufferLineErrorSelected", { fg = p.red, bg = p.bg })
	set(0, "BufferLineErrorDiagnostic", { fg = p.red, bg = p.dark })
	set(0, "BufferLineErrorDiagnosticVisible", { fg = p.red, bg = p.dark })
	set(0, "BufferLineErrorDiagnosticSelected", { fg = p.red, bg = p.bg })

	set(0, "DressingSelectIdx", { fg = p.orange, bold = true })
	set(0, "LazyGitFloat", { fg = p.fg, bg = p.dark })
	set(0, "LazyGitBorder", { fg = p.brown, bg = p.dark })
	set(0, "FidgetNoBlend", { bg = p.dark })
	set(0, "GitSignsAddPreview", { fg = p.moss, bg = p.dark })
	set(0, "GitSignsDeletePreview", { fg = p.red, bg = p.dark })
	set(0, "GitSignsCurrentLineBlame", { fg = p.comment, italic = true })
	set(0, "GitSignsAddInline", { bg = p.moss, fg = p.bg })
	set(0, "GitSignsChangeInline", { bg = p.gold, fg = p.bg })
	set(0, "GitSignsDeleteInline", { bg = p.red, fg = p.bg })
	set(0, "GitSignsDeleteVirtLn", { fg = p.red })
	set(0, "GitSignsDeleteVirtLnInLine", { fg = p.red })
	set(0, "GitSignsVirtLnum", { fg = p.comment })
end

function M.lualine_theme(theme_name)
	local resolved_theme = resolve_theme(theme_name or applied_theme or read_omarchy_theme())
	if resolved_theme ~= "miasma" then
		return "kanagawa"
	end

	return {
		normal = {
			a = { bg = miasma_palette.green, fg = miasma_palette.bg, gui = "bold" },
			b = { bg = miasma_palette.dark, fg = miasma_palette.green },
			c = { bg = miasma_palette.bg, fg = miasma_palette.fg },
		},
		insert = {
			a = { bg = miasma_palette.orange, fg = miasma_palette.bg, gui = "bold" },
			b = { bg = miasma_palette.dark, fg = miasma_palette.orange },
			c = { bg = miasma_palette.bg, fg = miasma_palette.fg },
		},
		visual = {
			a = { bg = miasma_palette.gold, fg = miasma_palette.bg, gui = "bold" },
			b = { bg = miasma_palette.dark, fg = miasma_palette.gold },
			c = { bg = miasma_palette.bg, fg = miasma_palette.fg },
		},
		replace = {
			a = { bg = miasma_palette.red, fg = miasma_palette.bg, gui = "bold" },
			b = { bg = miasma_palette.dark, fg = miasma_palette.red },
			c = { bg = miasma_palette.bg, fg = miasma_palette.fg },
		},
		command = {
			a = { bg = miasma_palette.moss, fg = miasma_palette.bg, gui = "bold" },
			b = { bg = miasma_palette.dark, fg = miasma_palette.moss },
			c = { bg = miasma_palette.bg, fg = miasma_palette.fg },
		},
		inactive = {
			a = { bg = miasma_palette.bg, fg = miasma_palette.comment, gui = "bold" },
			b = { bg = miasma_palette.bg, fg = miasma_palette.comment },
			c = { bg = miasma_palette.bg, fg = miasma_palette.comment },
		},
	}
end

local function refresh_lualine(theme_name)
	local ok, lualine = pcall(require, "lualine")
	if not ok then
		return
	end

	local config = vim.deepcopy(lualine.get_config())
	config.options.theme = M.lualine_theme(theme_name)
	lualine.setup(config)
	lualine.refresh({ force = true })
end

function M.apply(theme_name)
	local resolved_theme = resolve_theme(theme_name or read_omarchy_theme())
	if applied_theme == resolved_theme then
		return resolved_theme
	end

	if resolved_theme == "kanagawa" and not setup_kanagawa() then
		return nil
	end

	local ok, err = pcall(vim.cmd.colorscheme, resolved_theme)
	if not ok then
		vim.schedule(function()
			vim.notify(err, vim.log.levels.ERROR)
		end)
		return nil
	end

	apply_highlights(resolved_theme)
	refresh_lualine(resolved_theme)
	applied_theme = resolved_theme
	return resolved_theme
end

function M.apply_from_omarchy()
	return M.apply(read_omarchy_theme())
end

function M.setup()
	M.apply_from_omarchy()

	if watcher then
		return
	end

	watcher = uv.new_fs_event()
	if not watcher then
		return
	end

	watcher:start(omarchy_theme_dir, {}, vim.schedule_wrap(function(_, filename)
		if filename ~= "theme.name" then
			return
		end

		M.apply_from_omarchy()
	end))

	vim.api.nvim_create_autocmd("VimLeavePre", {
		once = true,
		callback = function()
			if watcher then
				watcher:stop()
				watcher:close()
				watcher = nil
			end
		end,
	})
end

return M
