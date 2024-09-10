local HL = {
	st_hi = 'WindowPickerStatusLine',
	st_hi_nc = 'WindowPickerStatusLineNC',
	wb_hi = 'WindowPickerWinBar',
	wb_hi_nc = 'WindowPickerWinBarNC',
}

local StatuslineHint = require('window-picker.hints.statusline-hint')

---@class StatuslineWinbarHint
local M = StatuslineHint:new()

function M:set_config(config)
	self.chars = config.chars
	self.show_prompt = config.show_prompt

	self.selection_display =
		config.picker_config.statusline_winbar_picker.selection_display
	self.use_winbar = config.picker_config.statusline_winbar_picker.use_winbar

	self.highlights = config.highlights

	self.opt_cap = {
		statusline = {
			g = {
				{
					name = 'laststatus',
					value = 2,
				},
				{
					name = 'cmdheight',
					value = 1,
				},
			},
			w = { { name = 'statusline' } },
		},
		winbar = {
			g = {},
			w = { { name = 'winbar' } },
		},
	}

	self.opt_save = {
		g = {},
		w = {},
	}

	self.hl_ns_save = {}

	self.statusline_hl_ns = vim.api.nvim_create_namespace('')
	self.winbar_hl_ns = vim.api.nvim_create_namespace('')

	self:set_plugin_hl()
end

function M.create_hl(namespace, name, properties)
	if type(properties) == 'table' then
		vim.api.nvim_set_hl(namespace, name, properties)
	end
end

--- Shows the characters in status line
--- @param windows number[] windows to draw the hints on
function M:draw(windows)
	local hint_type = self:get_hint_type()

	local g_opts_to_cap = self.opt_cap[hint_type].g
	local w_opts_to_cap = self.opt_cap[hint_type].w

	self:set_global_opts(g_opts_to_cap)
	self:set_temp_hint_hl(hint_type)

	for index, window in ipairs(windows) do
		self:set_win_opts(window, w_opts_to_cap)
		self:set_win_hl(window, hint_type)

		local char = self.chars[index]
		local display_text = self.selection_display
				and self.selection_display(char, window)
			or '%=' .. char .. '%='

		local ok, result =
			pcall(vim.api.nvim_win_set_option, window, hint_type, display_text)

		if not ok then
			local buffer = vim.api.nvim_win_get_buf(window)
			local message = 'Unable to set '
				.. hint_type
				.. ' for window id::'
				.. window
				.. '\n'
				.. 'filetype::'
				.. vim.bo[buffer]['filetype']
				.. '\n'
				.. 'consider ignoring unwanted windows using filter options\n'
				.. 'actual error\n'
				.. result

			vim.notify(message, vim.log.levels.WARN)
		end
	end

	vim.cmd.redraw()
end

--- clear the screen after print
function M:clear()
	self:restore_global_opts()
	self:restore_win_opts()
	self:restore_win_hl()
end

function M:set_global_opts(opts)
	for _, opt in ipairs(opts) do
		local curr = vim.o[opt.name]
		vim.o[opt.name] = opt.value

		table.insert(self.opt_save.g, {
			name = opt.name,
			value = curr,
		})
	end
end

function M:set_win_opts(window, opts)
	for _, opt in ipairs(opts) do
		table.insert(self.opt_save.w, {
			window = window,
			name = opt.name,
			value = vim.wo[window][opt.name],
		})

		if opt.value then
			vim.wo[window][opt.name] = opt.value
		end
	end
end

function M:restore_global_opts()
	for index, opt in ipairs(self.opt_save.g) do
		vim.o[opt.name] = opt.value
		self.opt_save.g[index] = nil
	end
end

function M:restore_win_opts()
	for index, opt in ipairs(self.opt_save.w) do
		if vim.api.nvim_win_is_valid(opt.window) then
			vim.wo[opt.window][opt.name] = opt.value
		end
		self.opt_save.w[index] = nil
	end
end

function M:get_hint_type()
	local use_winbar = false

	-- calculate if we should use winbar or not
	if self.use_winbar == 'always' then
		use_winbar = true
	elseif self.use_winbar == 'never' then
		use_winbar = false
	elseif self.use_winbar == 'smart' then
		use_winbar = vim.o.cmdheight == 0
	end

	if use_winbar then
		return 'winbar'
	end

	return 'statusline'
end

function M:set_plugin_hl()
	M.create_hl(
		self.statusline_hl_ns,
		HL.st_hi,
		self.highlights.statusline.focused
	)
	M.create_hl(
		self.statusline_hl_ns,
		HL.st_hi_nc,
		self.highlights.statusline.unfocused
	)

	M.create_hl(self.winbar_hl_ns, HL.wb_hi, self.highlights.winbar.focused)

	M.create_hl(
		self.winbar_hl_ns,
		HL.wb_hi_nc,
		self.highlights.winbar.unfocused
	)
end

function M:set_temp_hint_hl(hint_type)
	if hint_type == 'statusline' then
		local st_hl = M.get_hl(self.statusline_hl_ns, HL.st_hi)
		local st_hl_nc = M.get_hl(self.statusline_hl_ns, HL.st_hi_nc)

		vim.api.nvim_set_hl(self.statusline_hl_ns, 'StatusLine', st_hl)
		vim.api.nvim_set_hl(self.statusline_hl_ns, 'StatusLineNC', st_hl_nc)
	else
		local wb_hl = M.get_hl(self.winbar_hl_ns, HL.wb_hi)
		local wb_hl_nc = M.get_hl(self.winbar_hl_ns, HL.wb_hi_nc)

		vim.api.nvim_set_hl(self.winbar_hl_ns, 'WinBar', wb_hl)
		vim.api.nvim_set_hl(self.winbar_hl_ns, 'WinBarNC', wb_hl_nc)
	end
end

function M.get_hl(namespace, name)
	local hl = vim.api.nvim_get_hl(namespace, {
		name = name,
	})

	if not vim.tbl_isempty(hl) then
		return hl
	end

	return vim.api.nvim_get_hl(0, {
		name = name,
	})
end

function M:set_win_hl(window, hint_type)
	if hint_type == 'statusline' then
		vim.api.nvim_win_set_hl_ns(window, self.statusline_hl_ns)
	else
		vim.api.nvim_win_set_hl_ns(window, self.winbar_hl_ns)
	end

	table.insert(self.hl_ns_save, window)
end

function M:restore_win_hl()
	for _, window in ipairs(self.hl_ns_save) do
		if vim.api.nvim_win_is_valid(window) then
			vim.api.nvim_win_set_hl_ns(window, 0)
		end
	end
end

return M
