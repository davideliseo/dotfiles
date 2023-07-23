require('hop').setup {
    case_insensitive = true,
}

local hop = require('hop')
local directions = require('hop.hint').HintDirection
local positions = require('hop.hint').HintPosition
local opt = {
    noremap = true,
    silent = true
}

vim.keymap.set('', '<Leader>f', function()
    hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true
    })
end, opt)

vim.keymap.set('', '<Leader>F', function()
    hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true
    })
end, opt)

vim.keymap.set('', '<Leader>t', function()
    hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1
    })
end, opt)

vim.keymap.set('', '<Leader>T', function()
    hop.hint_char1({
        direction = directions.BEFORE_CURSOR,
        current_line_only = true,
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

vim.keymap.set('', '<Leader>w', function()
    hop.hint_words({
        direction = directions.AFTER_CURSOR,
        current_line_only = false
    })
end, opt)

vim.keymap.set('', '<Leader>b', function()
    hop.hint_words({
        direction = directions.BEFORE_CURSOR,
        current_line_only = false
    })
end, opt)

vim.keymap.set('', '<Leader>e', function()
    hop.hint_words({
        direction = directions.AFTER_CURSOR,
        hint_position = positions.END,
        current_line_only = false
    })
end, opt)

vim.keymap.set('', '<Leader>ge', function()
    hop.hint_words({
        direction = directions.BEFORE_CURSOR,
        hint_position = positions.END,
        current_line_only = false
    })
end, opt)

vim.keymap.set('', '<Leader>/', function()
    hop.hint_patterns({
        current_line_only = false
    })
end, opt)
