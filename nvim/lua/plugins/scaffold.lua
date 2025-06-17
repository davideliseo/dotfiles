return {
  {
    'lmburns/lf.nvim',
    cmd = 'Lf',
    keys = {
      { '<Leader>fe', function() require('lf').start() end, desc = 'LF file manager' },
    },
    opts = {
      escape_quit = false,
      border = 'single',
      winblend = 0,
    },
    dependencies = { 'akinsho/toggleterm.nvim' },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<Leader>gg", "<cmd>LazyGit<cr>", desc = "Git client" },
        { "<Leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "Git client, filter current file" }
    },
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      magic_window = true,
      previous_winid_ft_skip = {},
      preview = {
        auto_preview = true,
        border = 'rounded',
        show_title = true,
        show_scroll_bar = true,
        delay_syntax = 50,
        winblend = 6,
        win_height = 15,
        win_vheight = 15,
        wrap = false,
        buf_label = true,
        should_preview_cb = nil
      },
      func_map = {
        open = '<CR>',
        openc = 'o',
        drop = 'O',
        split = '<C-x>',
        vsplit = '<C-v>',
        tab = 't',
        tabb = 'T',
        tabc = '<C-t>',
        tabdrop = '',
        ptogglemode = 'zp',
        ptoggleitem = 'p',
        ptoggleauto = 'P',
        pscrollup = '<C-b>',
        pscrolldown = '<C-f>',
        pscrollorig = 'zo',
        prevfile = '<C-p>',
        nextfile = '<C-n>',
        prevhist = '<',
        nexthist = '>',
        lastleave = [['"]],
        stoggleup = '<S-Tab>',
        stoggledown = '<Tab>',
        stogglevm = '<Tab>',
        stogglebuf = [['<Tab>]],
        sclear = 'z<Tab>',
        filter = 'zn',
        filterr = 'zN',
        fzffilter = ''
      },
    },
    init = function()
      local fn = vim.fn
      function _G.qftf(info)
        local items
        local ret = {}
        -- The name of item in list is based on the directory of quickfix window.
        -- Change the directory for quickfix window make the name of item shorter.
        -- It's a good opportunity to change current directory in quickfixtextfunc :)
        --
        -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
        -- local root = getRootByAlterBufnr(alterBufnr)
        -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
        --
        if info.quickfix == 1 then
          items = fn.getqflist({ id = info.id, items = 0 }).items
        else
          items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
        end
        local limit = 60
        local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
        local validFmt = '%s │%5d:%-3d│%s %s'
        for i = info.start_idx, info.end_idx do
          local e = items[i]
          local fname = ''
          local str
          if e.valid == 1 then
            if e.bufnr > 0 then
              fname = fn.bufname(e.bufnr)
              if fname == '' then
                fname = '[No Name]'
              else
                fname = fname:gsub('^' .. vim.env.HOME, '~')
              end
              -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
              if #fname <= limit then
                fname = fnameFmt1:format(fname)
              else
                fname = fnameFmt2:format(fname:sub(1 - limit))
              end
            end
            local lnum = e.lnum > 99999 and -1 or e.lnum
            local col = e.col > 999 and -1 or e.col
            local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
            str = validFmt:format(fname, lnum, col, qtype, e.text)
          else
            str = e.text
          end
          table.insert(ret, str)
        end
        return ret
      end

      vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
    end
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
      notify = false,
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
            { action = "Telescope live_grep",                                      desc = "Buscar texto",                key = "s" },
            { action = 'lua require("persistence").load()',                        desc = "Restablecer sesión anterior", key = "l" },
            { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = "Configuración",               key = "c" },
            { action = "Lazy",                                                     desc = "Plugins",                     key = "p" },
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
