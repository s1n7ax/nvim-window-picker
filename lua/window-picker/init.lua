local builder = require('window-picker.builder')
local dconfig = require('window-picker.config')

local M = {}

function M.pick_window(custom_config)
	local config = dconfig

	-- merge the config
	if custom_config then
		config = vim.tbl_deep_extend('force', config, custom_config)
	end

	local hint

	if type(config.hint) == 'string' then
		local ok, result =
			pcall(require, ('window-picker.hints.%s-hint'):format(config.hint))

		if not ok then
			vim.notify(
				('No hint found by the name "%s"\nError: %s'):format(
					config.hint,
					result
				),
				vim.log.levels.ERROR
			)

			return
		end

		hint = result:new()
	else
		hint = config.hint
	end

	return builder:new():set_config(config):set_hint(hint):build():pick_window()
end

function M.setup(opts)
	if opts then
		dconfig = vim.tbl_deep_extend('force', dconfig, opts)
	end

	-- Setting highlights at global level
	-- highlight config is deleted so hint classes will only receive the
	-- highlights from config passed to pick_window() function explicitly
	--
	-- Behaviour:
	-- WHEN user wants nether global nor default config, highlights can be
	-- disabled
	--
	-- WHEN global highlights are already set,
	--	IF pick_window() has no highlight config
	--		EXPECTED to use global highlights
	--	IF pick_window({highlights}) has highlight config
	--		EXPECTED to override only the passed highlights ONLY
	--
	-- WHEN global highlights are NOT set
	--	IF pick_window() has no highlight config
	--		EXPECTED to use default config highlights
	--	IF pick_window({highlights}) has highlight config
	--		EXPECTED to override only the passed highlights ONLY

	if not dconfig.highlights.enabled then
		return
	end

	M._create_hl_if_not_exists(
		'WindowPickerStatusLine',
		dconfig.highlights.statusline.focused
	)

	M._create_hl_if_not_exists(
		'WindowPickerStatusLineNC',
		dconfig.highlights.statusline.unfocused
	)

	M._create_hl_if_not_exists(
		'WindowPickerWinBar',
		dconfig.highlights.winbar.focused
	)

	M._create_hl_if_not_exists(
		'WindowPickerWinBarNC',
		dconfig.highlights.winbar.unfocused
	)

	dconfig.highlights = {
		statusline = {
			focused = {},
			unfocused = {},
		},
		winbar = {
			focused = {},
			unfocused = {},
		},
	}
end

function M._create_hl_if_not_exists(name, properties)
	if type(properties) ~= 'table' then
		return
	end

	local hl = vim.api.nvim_get_hl(0, {
		name = name,
	})

	if not vim.tbl_isempty(hl) then
		return
	end

	vim.api.nvim_set_hl(0, name, properties)
end

return M
