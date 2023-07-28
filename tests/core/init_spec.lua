local function get_hl(name)
	return vim.api.nvim_get_hl(0, {
		name = name,
	})
end

describe('core::', function()
	describe('setup', function()
		it('default highlights are set when setup', function()
			local highlights = {
				{
					name = 'WindowPickerStatusLine',
					expected = {
						fg = tonumber('ededed', 16),
						bg = tonumber('e35e4f', 16),
						bold = true,
						cterm = {
							bold = true,
						},
					},
				},
				{
					name = 'WindowPickerStatusLineNC',
					expected = {
						fg = tonumber('ededed', 16),
						bg = tonumber('44cc41', 16),
						bold = true,
						cterm = {
							bold = true,
						},
					},
				},
				{
					name = 'WindowPickerWinBar',
					expected = {
						fg = tonumber('ededed', 16),
						bg = tonumber('e35e4f', 16),
						bold = true,
						cterm = {
							bold = true,
						},
					},
				},
				{
					name = 'WindowPickerWinBarNC',
					expected = {
						fg = tonumber('ededed', 16),
						bg = tonumber('44cc41', 16),
						bold = true,
						cterm = {
							bold = true,
						},
					},
				},
			}
			for _, hl in ipairs(highlights) do
				assert(vim.tbl_isempty(get_hl(hl.name)))
			end

			require('window-picker').setup()

			for _, hl in ipairs(highlights) do
				assert(vim.deep_equal(hl.expected, get_hl(hl.name)))
			end
		end)

		it(
			'ignores setting default highlights when hl are already present',
			function()
				local highlights = {
					{
						name = 'WindowPickerStatusLine',
						expected = {
							fg = tonumber('4287f5', 16),
							bg = tonumber('63f542', 16),
						},
					},
				}

				for _, hl in ipairs(highlights) do
					vim.api.nvim_set_hl(0, hl.name, hl.expected)
				end

				require('window-picker').setup()

				for _, hl in ipairs(highlights) do
					assert(vim.deep_equal(get_hl(hl.name), hl.expected))
				end
			end
		)
	end)
end)
