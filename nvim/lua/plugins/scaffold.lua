return {
  {
    'lmburns/lf.nvim',
    cmd = 'Lf',
    keys = {
      { '<C-l>', function() require('lf').start() end, desc = 'LF file manager' },
    },
    opts = {
      escape_quit = true,
      border = 'single',
      winblend = 0,
    },
    dependencies = { 'akinsho/toggleterm.nvim' },
  },
  {
    'romgrk/barbar.nvim',
    cond = false,
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      icons = {
        button = '󰅗',
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      ignore_missing = false,
    },
    config = function(_, opts)
      require('which-key').setup(opts)
      require('which-key').register({
        ['<Leader>v'] = { name = 'view' },
        ['<Leader>l'] = { name = 'lsp' },
        ['<Leader>k'] = { name = 'macrothis' },
      })
    end
  },
  {
    'folke/todo-comments.nvim',
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'desdic/macrothis.nvim',
    opts = {},
    keys = {
      { '<Leader>kd', function() require('macrothis').delete() end,                  desc = 'Delete macro' },
      { '<Leader>ke', function() require('macrothis').edit() end,                    desc = 'Edit macro' },
      { '<Leader>kl', function() require('macrothis').load() end,                    desc = 'Load macro' },
      { '<Leader>kn', function() require('macrothis').rename() end,                  desc = 'Rename macro' },
      { '<Leader>kq', function() require('macrothis').quickfix() end,                desc = 'Run macro on all files in quickfix' },
      { '<Leader>kr', function() require('macrothis').run() end,                     desc = 'Run macro' },
      { '<Leader>ks', function() require('macrothis').save() end,                    desc = 'Save macro' },
      { '<Leader>kx', function() require('macrothis').register() end,                desc = 'Edit register' },
      { '<Leader>kp', function() require('macrothis').copy_register_printable() end, desc = 'Copy register as printable' },
      { '<Leader>km', function() require('macrothis').copy_macro_printable() end,    desc = 'Copy macro as printable' },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[水滴石穿，不是力量大，而是功夫深]]
      logo = string.rep("\n", 8) .. logo .. string.rep("\n", 3)

      local opts = {
        theme = "doom",
        hide = {
          -- This is taken care of by lualine
          -- Enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            { action = "Telescope smart_open",                                     desc = "Buscar archivo",              key = "f" },
            { action = "ene | startinsert",                                        desc = "Nuevo archivo",               key = "n" },
            { action = "Telescope oldfiles",                                       desc = "Archivos recientes",          key = "r" },
            { action = "Telescope live_grep",                                      desc = "Buscar texto",                key = "g" },
            { action = 'lua require("persistence").load()',                        desc = "Restablecer sesión anterior", key = "s" },
            { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = "Configuración",               key = "c" },
            { action = "Lazy",                                                     desc = "Plugins",                     key = "l" },
            { action = "qa",                                                       desc = "Salir",                       key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "", "Neovim cargó " .. stats.loaded .. "/" .. stats.count .. " plugins en " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "[%s]"
      end

      -- Close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function() require("lazy").show() end,
        })
      end

      return opts
    end,
  },
}
