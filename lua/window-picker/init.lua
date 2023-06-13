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
		local ok, result = pcall(
			require,
			('window-picker.hints.%s-hint'):format(config.hint)
		)

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
		dconfig = vim.tbl_deep_extend("force", dconfig, opts)
	end
end

return M
