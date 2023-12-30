return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    cmd = 'Telescope',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require("telescope")
      local builtin = require('telescope.builtin')
      local actions = require('telescope.actions')
      local extensions = telescope.extensions

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-h>'] = 'which_key',
              ['<C-Space>'] = function(bufnr) extensions.hop.hop(bufnr) end,
              ['<Esc>'] = actions.close,
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

      require('which-key').register({
        ['<Leader>q'] = {
          name = 'telescope',
          ['f'] = { extensions.smart_open.smart_open, 'Files (smart)' },
          ['F'] = { builtin.find_files, 'Files' },
          ['G'] = { builtin.git_files, 'Git files' },
          ['o'] = { builtin.lsp_document_symbols, 'LSP document symbols' },
          ['r'] = { builtin.lsp_references, 'LSP references' },
          ['d'] = { builtin.diagnostics, 'LSP diagnostics' },
          ['g'] = { builtin.live_grep, 'Live grep' },
          ['b'] = { builtin.buffers, 'Buffers' },
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
