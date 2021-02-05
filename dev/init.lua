-- This file contains configurations to use in the development process

-- force lua to import the modules again
package.loaded['dev'] = nil
package.loaded['greetings'] = nil
package.loaded['greetings.awesome-module'] = nil

-- keybind to re source the lua file
vim.api.nvim_set_keymap('n', ',r', '<cmd>luafile dev/init.lua<cr>', {})

-- keybind to test the plugin
Greetings = require('greetings')
vim.api.nvim_set_keymap('n', ',w', '<cmd>lua Greetings.greet()<cr>', {})
