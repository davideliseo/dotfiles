-- 'clear = true' must be set to prevent loading an auto-command repeatedly every time a file is resourced
local group = vim.api.nvim_create_augroup('Custom auto-commands', { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd('FileType', {
  pattern = { 'cs' },
  desc = 'Set 4 space tabs for languages where it is more common.',
  callback = function(event)
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

autocmd({ 'VimResized' }, {
  desc = 'Resize panes if window got resized',
  group = group,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

autocmd('BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  group = group,
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, "'")
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd('BufWritePre', {
  pattern = { '*.js', '*.ts', '*.jsx', '*.tsx' },
  desc = 'Auto-format JS/TS files after saving',
  group = group,
  callback = function(args)
    vim.lsp.buf.format({
      timeout_ms = 5000,
      filter = function(client)
        return client.name == "null-ls"
      end,
    })
  end,
})

autocmd('BufWritePre', {
  pattern = { '*.dart' },
  desc = 'Auto-format Dart files after saving',
  group = group,
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 5000 })
    vim.lsp.buf.code_action({
      apply = true, -- Execute without user input if there's only one action available
      filter = function(action) return action.kind == 'source.fixAll' end,
    })
  end,
})
