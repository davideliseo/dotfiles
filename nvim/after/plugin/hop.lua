require('hop').setup {
  case_insensitive = true
}

local hop = require('hop')
local directions = require('hop.hint').HintDirection
local positions = require('hop.hint').HintPosition
local opt = {
  noremap = true,
  silent = true
}

vim.keymap.set('', '<leader>f', function()
  hop.hint_char1({
    direction = directions.AFTER_CURSOR,
    current_line_only = false
  })
end, opt)

vim.keymap.set('', '<leader>F', function()
  hop.hint_char1({
    direction = directions.BEFORE_CURSOR,
    current_line_only = false
  })
end, opt)

vim.keymap.set('', '<leader>t', function()
  hop.hint_char1({
    direction = directions.AFTER_CURSOR,
    current_line_only = false,
    hint_offset = -1
  })
end, opt)

vim.keymap.set('', '<leader>T', function()
  hop.hint_char1({
    direction = directions.BEFORE_CURSOR,
    current_line_only = false,
    hint_offset = 1
  })
end, opt)

vim.keymap.set('', 's', function()
  hop.hint_char2({
    direction = directions.AFTER_CURSOR,
    current_line_only = false
  })
end, opt)

vim.keymap.set('', 'S', function()
  hop.hint_char2({
    direction = directions.BEFORE_CURSOR,
    current_line_only = false
  })
end, opt)

vim.keymap.set('', '<leader>w', function()
  hop.hint_camel_case({
    direction = directions.AFTER_CURSOR,
    current_line_only = false
  })
end, opt)

vim.keymap.set('', '<leader>b', function()
  hop.hint_camel_case({
    direction = directions.BEFORE_CURSOR,
    current_line_only = false
  })
end, opt)

vim.keymap.set('', '<leader>e', function()
  hop.hint_camel_case({
    direction = directions.AFTER_CURSOR,
    hint_position = positions.END,
    current_line_only = false
  })
end, opt)

vim.keymap.set('', '<leader>ge', function()
  hop.hint_camel_case({
    direction = directions.BEFORE_CURSOR,
    hint_position = positions.END,
    current_line_only = false
  })
end, opt)

vim.keymap.set('', '<leader>/', function()
  hop.hint_patterns({
    current_line_only = false
  })
end, opt)

vim.keymap.set('', '<leader>j', function()
  hop.hint_lines_skip_whitespace({
    direction = directions.AFTER_CURSOR,
  })
end, opt)

vim.keymap.set('', '<leader>k', function()
  hop.hint_lines_skip_whitespace({
    direction = directions.BEFORE_CURSOR,
  })
end, opt)

vim.keymap.set('', '<leader>gj', function()
  hop.hint_vertical({
    direction = directions.AFTER_CURSOR,
  })
end, opt)

vim.keymap.set('', '<leader>gk', function()
  hop.hint_vertical({
    direction = directions.BEFORE_CURSOR,
  })
end, opt)
