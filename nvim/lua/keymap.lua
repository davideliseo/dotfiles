local wk = require('which-key')

wk.register({
  ['j'] = { 'jzz', 'Go down one line and center' },
  ['k'] = { 'kzz', 'Go up one line and center' },
  ['/'] = { '/\\v', 'Search text with "very magic" mode', mode = { 'n', 'v' }, noremap = false } ,
})
