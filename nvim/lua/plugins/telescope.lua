return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { '<Leader>q' },
    config = function()
      local telescope = require("telescope")
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      local extensions = telescope.extensions

      telescope.setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              preview_height = 0.5,
            },
          },
          mappings = {
            i = {
              ['<C-h>'] = 'which_key',
              ['<C-Space>'] = function(bufnr) extensions.hop.hop(bufnr) end,
              ['<Esc>'] = actions.close,
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
              ['<M-q>'] = false,
            },
          },
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--trim', -- remove ripgrep indentation
          },
        },
        extensions = {
          smart_open = {
            show_scores = true,
            ignore_patterns = { '*.git/*', '*/tmp/*', '*/node_modules/*' },
            match_algorithm = 'fzf',
            disable_devicons = false,
            open_buffer_indicators = {
              previous = '<-',
              others = '...',
            },
          },
          hop = {
            keys = { 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
              'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
              'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L',
              'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P' },
            sign_hl = { 'WarningMsg', 'Title' },
            line_hl = { 'CursorLine', 'Normal' },
            clear_selection_hl = false,
            trace_entry = true,
            reset_selection = true,
          },
        },
      })

      telescope.load_extension('hop')
      telescope.load_extension('smart_open')
      telescope.load_extension('macrothis')
      telescope.load_extension('flutter')

      vim.api.nvim_create_augroup('Telescope', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'TelescopePreviewerLoaded' },
        callback = function()
          vim.opt_local.number = true
        end,
      })

      vim.api.nvim_set_hl(0, 'TelescopeMatching', { link = 'Constant' })

      require('which-key').register({
        ['<Leader>f'] = {
          name = 'files',
          ['f'] = { extensions.smart_open.smart_open, 'Find files (smart)' },
          ['r'] = { builtin.oldfiles, 'Recent files' },
        },
        ['<Leader>s'] = {
          name = 'search',
          ['s'] = { builtin.live_grep, 'Fuzzy search' },
          ['e'] = {
            function()
              builtin.grep_string({
                search = '',
                use_regex = true,
                word_match = '-w',
              })
            end,
            'Exact search',
          },
          ['v'] = {
            function()
              builtin.grep_string({
                search = require("utils").get_visual_selection({
                  use_last_selection = false,
                }),
                use_regex = true,
                word_match = "-w",
              })
            end,
            'Exact search (visual selection or under cursor)',
            mode = { "x", "n" },
          },
          ['h'] = { builtin.search_history, 'Search history' },
        },
        ['<Leader>p'] = {
          name = 'pickers',
          ['b'] = { builtin.buffers, 'Buffers' },
          ['q'] = { builtin.quickfix, 'Quickfix' },
          ['c'] = { builtin.commands, 'Commands' },
          ['m'] = { builtin.marks, 'Marks' },
        },
      })
    end,
  },
  {
    "danielfalk/smart-open.nvim",
    cmd = 'Telescope smart_open',
    branch = "0.2.x",
    dependencies = {
      "kkharji/sqlite.lua",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
  {
    'nvim-telescope/telescope-hop.nvim',
  },
}
