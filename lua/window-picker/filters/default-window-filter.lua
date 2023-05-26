local util = require('window-picker.util')

--- @class DefaultWindowFilter
--- @field filter_stack function[]
--- @field window_options table<string, any> window options to filter
--- @field window_configs table<string, any> window configs to filter
--- @field window_ids table<string, any> window ids to include
--- @field not_window_ids table<string, any> window ids to exclude
--- @field buffer_options table<string, any> buffer options to filter
--- @field file_name_contains string[] file names to filter
--- @field file_path_contains string[] file paths to filter
local M = {}

function M:new()
	local o = {}

	setmetatable(o, self)
	self.__index = self

	o.filter_stack = {
		o._window_config_filter,
		o._window_option_filter,
		o._buffer_options_filter,
		o._file_path_contains_filter,
		o._file_path_contains_filter,
		o._window_id_filter,
		o._not_window_id_filter,
		o._current_window_filter,
	}

	return o
end

function M:set_config(config)
	self.window_options = config.wo or {}
	self.buffer_options = config.bo or {}
	self.window_configs = config.window_configs or {}
	self.file_name_contains = config.file_name_contains or {}
	self.file_path_contains = config.file_path_contains or {}
	self.window_ids = config.window_ids or {}
	self.not_window_ids = config.not_window_ids or {}
	self.include_current_win = config.include_current_win
end

function M:filter_windows(windows)
	local filtered_windows = windows

	for _, filter in ipairs(self.filter_stack) do
		filtered_windows = filter(self, filtered_windows)
	end

	return filtered_windows
end

function M:_window_config_filter(windows)
	if self.window_configs and vim.tbl_count(self.window_configs) > 0 then
		return util.tbl_filter(windows, function(winid)
			local config = vim.api.nvim_win_get_config(winid)
			for cfg_key, cfg_values in pairs(self.window_configs) do
				local actual_opt = config[cfg_key]

				local has_value = false

				if type(cfg_values) == 'table' then
					has_value = vim.tbl_contains(cfg_values, actual_opt)
				elseif cfg_values == true then
					has_value = actual_opt ~= '' and actual_opt ~= nil
				end

				if has_value then
					return false
				end
			end

			return true
		end)
	else
		return windows
	end
end

function M:_window_option_filter(windows)
	if self.window_options and vim.tbl_count(self.window_options) > 0 then
		return util.tbl_filter(windows, function(winid)
			for opt_key, opt_values in pairs(self.window_options) do
				local actual_opt = vim.api.nvim_win_get_option(winid, opt_key)

				local has_value = vim.tbl_contains(opt_values, actual_opt)

				if has_value then
					return false
				end
			end

			return true
		end)
	else
		return windows
	end
end

function M:_window_id_filter(windows)
	if self.window_ids and vim.tbl_count(self.window_ids) > 0 then
		windows = util.tbl_filter(windows, function(winid)
			return vim.tbl_contains(self.window_ids, winid)
				and not vim.tbl_contains(self.not_window_ids, winid)
		end)
	end
	return windows
end
function M:_not_window_id_filter(windows)
	if self.not_window_ids and vim.tbl_count(self.not_window_ids) > 0 then
		windows = util.tbl_filter(windows, function(winid)
			return not vim.tbl_contains(self.not_window_ids, winid)
		end)
	end
	return windows
end

function M:_buffer_options_filter(windows)
	if self.buffer_options and vim.tbl_count(self.buffer_options) > 0 then
		return util.tbl_filter(windows, function(winid)
			local bufid = vim.api.nvim_win_get_buf(winid)

			for opt_key, opt_values in pairs(self.buffer_options) do
				local actual_opt = vim.api.nvim_buf_get_option(bufid, opt_key)

				local has_value = vim.tbl_contains(opt_values, actual_opt)

				if has_value then
					return false
				end
			end

			return true
		end)
	else
		return windows
	end
end

function M:_file_path_contains_filter(windows)
	if
		self.file_path_contains
		and vim.tbl_count(self.file_path_contains) > 0
	then
		return util.tbl_filter(windows, function(winid)
			local bufid = vim.api.nvim_win_get_buf(winid)
			local filepath = vim.api.nvim_buf_get_name(bufid)

			local has_match = util.tbl_any(
				self.file_path_contains,
				function(exp_path)
					exp_path = util.escape_pattern(exp_path)

					if filepath:find(exp_path) then
						return true
					end
				end
			)

			return not has_match
		end)
	else
		return windows
	end
end

function M:_file_name_contains_filter(windows)
	if
		self.file_name_contains
		and vim.tbl_count(self.file_name_contains) > 0
	then
		return util.tbl_filter(windows, function(winid)
			local bufid = vim.api.nvim_win_get_buf(winid)
			local filepath = vim.api.nvim_buf_get_name(bufid)
			local filename = filepath:match('^.*/(.+)$')

			local has_match = util.tbl_any(
				self.file_name_contains,
				function(exp_name)
					if filename:find(exp_name) then
						return true
					end
				end
			)

			return not has_match
		end)
	else
		return windows
	end
end

function M:_current_window_filter(windows)
	if self.include_current_win then
		return windows
	end

	local curr_win = vim.api.nvim_get_current_win()

	return util.tbl_filter(windows, function(winid)
		return winid ~= curr_win
	end)
end

return M
