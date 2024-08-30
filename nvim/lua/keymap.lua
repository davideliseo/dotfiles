local wk = require('which-key')

wk.register({
  ['<Leader>w'] = { '<CMD>w<CR>', 'Save current buffer' },
  ['<Leader>W'] = { '<CMD>wa<CR>', 'Save all buffers' },
  ['<Leader>q'] = { '<CMD>q<CR>', 'Close current buffer' },
  ['<Leader>t'] = { '<CMD>set wrap!<CR>', 'Toggle word wrap' },
  ['j'] = { 'jzz', 'Go down one line and center' },
  ['k'] = { 'kzz', 'Go up one line and center' },
  ['/'] = { '/\\v', 'Search text with "very magic" mode', mode = { 'n', 'v' }, noremap = false } ,
})
