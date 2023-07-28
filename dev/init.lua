local cwd = vim.fn.getcwd()
vim.opt.runtimepath:prepend(cwd)

--[[
-- plugin name will be used to reload the loaded modules
--]]
local package_name = 'window-picker'

-- add the escape character to special characters
local escape_pattern = function(text)
	return text:gsub('([^%w])', '%%%1')
end

-- unload loaded modules by the matching text
local unload_packages = function()
	local esc_package_name = escape_pattern(package_name)

	for module_name, _ in pairs(package.loaded) do
		if string.find(module_name, esc_package_name) then
			package.loaded[module_name] = nil
		end
	end
end

-- executes the run method in the package
local run_action = function()
	vim.cmd.messages('clear')

	require(package_name).setup({
		include_current_win = true,
		picker_config = {
			statusline_winbar_picker = {
				use_winbar = 'always', -- "always" | "never" | "smart"
			},
		},
		highlights = {
			statusline = {
				focused = {
					fg = 'yellow',
					bg = 'yellow',
					bold = true,
				},
				unfocused = {
					fg = 'yellow',
					bg = 'yellow',
					bold = true,
				},
			},
			winbar = {
				focused = {
					fg = 'red',
					bg = 'blue',
					bold = true,
				},
				unfocused = {
					fg = 'green',
					bg = 'black',
					bold = true,
				},
			},
		},
	})

	local window = require(package_name).pick_window({
		-- highlights = {
		-- 	enabled = false,
		-- 	statusline = {
		-- 		focused = {
		-- 			fg = 'blue',
		-- 			bg = 'red',
		-- 			bold = true,
		-- 		},
		-- 		unfocused = {
		-- 			fg = 'black',
		-- 			bg = 'white',
		-- 			bold = true,
		-- 		},
		-- 	},
		-- 	winbar = {
		-- 		focused = {
		-- 			fg = 'red',
		-- 			bg = 'blue',
		-- 			bold = true,
		-- 		},
		-- 		unfocused = {
		-- 			fg = 'green',
		-- 			bg = 'black',
		-- 			bold = true,
		-- 		},
		-- 	},
		-- },
	})

	if not window then
		print('result is nil')
		return
	end

	vim.api.nvim_set_current_win(window)
end

-- unload and run the function from the package
function _G.Reload_and_run()
	unload_packages()
	run_action()
end

---@diagnostic disable-next-line: undefined-global
local set_keymap = vim.api.nvim_set_keymap

set_keymap('n', '<leader><leader>r', '<cmd>luafile dev/init.lua<cr>', {})
set_keymap('n', '<leader><leader>w', '<cmd>lua Reload_and_run()<cr>', {})
