return {
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      indent = { char = '│' },
      scope = { enabled = false },
      exclude = {
        filetypes = { 'dashboard', 'ssr' },
      },
    },
  },
  {
    'karb94/neoscroll.nvim',
    name = 'neoscroll',
    event = 'WinScrolled',
    opts = {
      mappings = { '<C-u>', '<C-d>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
    },
    keys = function()
      local ns = require('neoscroll')
      do return end
      return {
        {
          'j',
          function()
            ns.scroll(math.max(1, vim.v.count), true, 150); vim.cmd('norm! zz')
          end,
          desc = 'Move cursor down and center viewport',
        },
        {
          'k',
          function()
            ns.scroll(-math.max(1, vim.v.count), true, 150); vim.cmd('norm! zz')
          end,
          desc = 'Move cursor up and center viewport',
        },
      }
    end,
  },
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
      },
      plugins = {
        tmux = { enabled = true }, -- 'true' disables tmux status bar
      },
    },
    keys = {
      { '<Leader>vz', function() require("zen-mode").toggle() end, desc = 'Toggle Zen Mode' },
    }
  },
}
