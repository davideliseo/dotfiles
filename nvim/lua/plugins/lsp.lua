return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },
  {
    -- <Ctrl-y>: Confirms selection.
    -- <Ctrl-e>: Cancel the completion.
    -- <Down>: Navigate to the next item on the list.
    -- <Up>: Navigate to previous item on the list.
    -- <Ctrl-n>: Go to the next item in the completion menu, or trigger completion menu.
    -- <Ctrl-p>: Go to the previous item in the completion menu, or trigger completion menu.
    -- <Ctrl-d>: Scroll down in the item's documentation.
    -- <Ctrl-u>: Scroll up in the item's documentation.
    --
    -- Extra mappings:
    -- <Ctrl-f>: Go to the next placeholder in the snippet.
    -- <Ctrl-b>: Go to the previous placeholder in the snippet.
    -- <Tab>: Enables completion when the cursor is inside a word. If the completion menu is visible it will navigate to the next item in the list.
    -- <Shift-Tab>: When the completion menu is visible navigate to the previous item in the list.
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        sources = {
          -- hrsh7th/cmp-nvim-lsp
          { name = 'nvim_lsp' },
          {
            -- hrsh7th/cmp-buffer
            name = 'buffer',
            option = {
              get_bufnrs = function() -- Visible buffers
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end
            },
          },
        },
        formatting = lsp_zero.cmp_format(),
        preselect = 'item',
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = {
          ['<Tab>'] = cmp.mapping.confirm({ select = true }),
          ['<C-p>'] = cmp.mapping.complete({ reason = cmp.ContextReason.Auto }),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        },
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'hrsh7th/cmp-buffer' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr }) -- see :help lsp-zero-keybindings to learn the available actions
      end)

      -- NOTE: dartls is configured by akinsho/flutter-tools.nvim
      -- require('lspconfig').dartls.setup({})

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = { 'tsserver' },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        }
      })
    end
  },
  {
    'akinsho/flutter-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    ft = "dart",
    opts = {
      flutter_lookup_cmd = 'asdf where flutter',
      widget_guides = {
        enabled = false,
      },
      closing_tags = {
        prefix = '-> ',
        enabled = true,
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      lsp = {
        settings = {
          lineLength = 100,
        },
        color = {
          enabled = true,
          background = false,
          background_color = { r = 0, g = 0, b = 0 },
          foreground = false,
          virtual_text = true,
          virtual_text_str = '■■',
        },
        on_attach = function()
          local wk = require('which-key')
          wk.register({
            ['<Leader>l'] = {
              name = 'lsp',
              ['l'] = {
                require('telescope').extensions.flutter.commands,
                'Flutter LSP commands',
              },
            },
          })
        end,
      },
    },
  },
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    event = 'LspAttach',
    keys = function()
      return {
        { "<Leader>lt", require("lsp_lines").toggle, desc = "Toggle LSP lines" },
      }
    end,
    config = function()
      require('lsp_lines').setup()
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = true,
      })
    end,
  },
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
