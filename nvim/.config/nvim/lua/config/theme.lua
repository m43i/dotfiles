local M = {}

local current_dir = vim.fn.expand("~/.local/state/omarchy/current")
local theme_file = current_dir .. "/theme/neovim.lua"
local watcher
local reload_timer

local function read_specs()
	local chunk, load_error = loadfile(theme_file)
	if not chunk then
		return nil, load_error
	end

	local ok, specs = pcall(chunk)
	if not ok or type(specs) ~= "table" then
		return nil, ok and "theme file did not return a plugin spec" or specs
	end

	return specs
end

local function theme_config()
	local specs, err = read_specs()
	if not specs then
		return nil, err
	end

	local plugins = {}
	local colorscheme

	for _, source in ipairs(specs) do
		if source[1] == "LazyVim/LazyVim" then
			colorscheme = source.opts and source.opts.colorscheme
		elseif source[1] then
			local plugin = vim.deepcopy(source)
			plugin.lazy = false
			plugin.priority = 1000
			table.insert(plugins, plugin)
		end
	end

	if not colorscheme then
		return nil, "theme file does not declare a colorscheme"
	end

	return {
		colorscheme = colorscheme,
		plugins = plugins,
	}
end

local function notify_error(err)
	vim.schedule(function()
		vim.notify("Unable to load Omarchy theme: " .. tostring(err), vim.log.levels.ERROR)
	end)
end

function M.apply(reload_plugin)
	local config, err = theme_config()
	if not config then
		notify_error(err)
		return
	end

	local loader = require("lazy.core.loader")
	local lazy_config = require("lazy.core.config")
	local spec = config.plugins[1]
	local plugin_name = spec and (spec.name or require("lazy.core.plugin").Spec.get_name(spec[1]))
	local plugin = plugin_name and lazy_config.plugins[plugin_name]

	if reload_plugin and plugin then
		loader.reload(plugin)
	else
		loader.colorscheme(config.colorscheme)
	end

	local ok, colorscheme_error = pcall(vim.cmd.colorscheme, config.colorscheme)
	if not ok then
		notify_error(colorscheme_error)
	end
end

function M.reload()
	local plugin_manager = require("lazy.core.plugin")
	local loader = require("lazy.core.loader")

	plugin_manager.load()
	while loader.install_missing() do
	end
	M.apply(true)
end

function M.setup()
	M.apply()

	if watcher then
		return
	end

	watcher = vim.uv.new_fs_event()
	reload_timer = vim.uv.new_timer()
	if not watcher or not reload_timer then
		return
	end

	watcher:start(current_dir, {}, vim.schedule_wrap(function(_, filename)
		if filename ~= "theme.name" then
			return
		end

		reload_timer:stop()
		reload_timer:start(100, 0, vim.schedule_wrap(M.reload))
	end))

	vim.api.nvim_create_autocmd("VimLeavePre", {
		once = true,
		callback = function()
			watcher:stop()
			watcher:close()
			reload_timer:stop()
			reload_timer:close()
			watcher = nil
			reload_timer = nil
		end,
	})
end

function M.specs()
	local config, err = theme_config()
	if not config then
		notify_error(err)
		return {}
	end

	table.insert(config.plugins, {
		name = "omarchy-theme",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 999,
		config = M.setup,
	})

	return config.plugins
end

return M
