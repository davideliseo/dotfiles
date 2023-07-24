local lsp = require('lsp-zero').preset({
  name = 'recommended',
  manage_nvim_cmp = {
    set_extra_mappings = true,
  }
})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

--[[
<Ctrl-y>: Confirms selection.
<Ctrl-e>: Cancel the completion.
<Down>: Navigate to the next item on the list.
<Up>: Navigate to previous item on the list.
<Ctrl-n>: Go to the next item in the completion menu, or trigger completion menu.
<Ctrl-p>: Go to the previous item in the completion menu, or trigger completion menu.
<Ctrl-d>: Scroll down in the item's documentation.
<Ctrl-u>: Scroll up in the item's documentation.

Extra mappings:
<Ctrl-f>: Go to the next placeholder in the snippet.
<Ctrl-b>: Go to the previous placeholder in the snippet.
<Tab>: Enables completion when the cursor is inside a word. If the completion menu is visible it will navigate to the next item in the list.
<Shift-Tab>: When the completion menu is visible navigate to the previous item in the list.
]]
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},  -- hrsh7th/cmp-nvim-lsp
    {
      name = 'buffer',  -- hrsh7th/cmp-buffer
      option = {
        get_bufnrs = function()  -- Buffers visibles
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      },
    },
  },
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = {
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }
})
