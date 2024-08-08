return {
  {
    -- s{char}<space>: jump to a character before the end of the line.
    -- s<space><space>: jump to an empty line (or any EOL position if Visual mode or virtualedit allows it)
    -- s{char}<enter>: jump to the first {char}{?} pair right away.
    -- s<enter>: repeat the last search.
    -- s<enter><enter>... or s{char}<enter><enter>...: traverse through the matches.
    -- search bidirectionally in the window, or bind only one key to Leap, and search in all windows, if you are okay with the trade-offs (see FAQ).
    -- map keys to repeat motions without explicitly invoking Leap, similar to how ; and , works (see :h leap-repeat-keys).
    'ggandor/leap.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    opts = {
      safe_labels = 'sfnmugtz', -- Keys unlinkely to be used after auto-jumping
      labels = 'sfnjklhodweimbuyvrgtaqpcxz',
      highlight_unlabeled_phase_one_targets = true,
      equivalence_classes = { ' \t\r\n', 'aá', 'eé', 'ií', 'oó', 'uú', ' ,;.:-_`+*!"#$%&/=\'¿?¡~^´¨', '()[]{}<>' },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do leap.opts[k] = v end
      leap.create_default_mappings()
    end,
    dependencies = { { "tpope/vim-repeat" } },
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>sr",
        function() require("ssr").open() end,
        mode = { "n", "x" },
        desc = "Structural search & replace",
      },
    },
    opts = {
      border = "rounded",
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      adjust_window = true,
      keymaps = {
        close = "<Esc>",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<Cr>",
        replace_all = "<Leader><Cr>",
      },
    },
  },
  {
    'smoka7/hop.nvim',
    cond = false,
    version = '*',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('hop').setup({
        case_insensitive = true,
        multi_windows = false,
      })

      local hop = require('hop')
      local directions = require('hop.hint').HintDirection
      local positions = require('hop.hint').HintPosition

      local wk = require('which-key')
      wk.register({
        ['s'] = {
          function()
            hop.hint_char2({
              direction = directions.AFTER_CURSOR,
              current_line_only = false
            })
          end,
          'Hop 2-char anywhere forwards',
          mode = { 'n', 'v', 'o' },
        },
        ['S'] = {
          function()
            hop.hint_char2({
              direction = directions.BEFORE_CURSOR,
              current_line_only = false
            })
          end,
          'Hop 2-char anywhere backwards',
          mode = { 'n', 'v', 'o' },
        },
        ['gs'] = {
          function()
            hop.hint_char2({
              direction = directions.AFTER_CURSOR,
              current_line_only = false,
              hint_offset = -1
            })
          end,
          'Hop 2-char anywhere forwards offset by 1',
          mode = { 'n', 'v', 'o' },
        },
        ['gS'] = {
          function()
            hop.hint_char2({
              direction = directions.BEFORE_CURSOR,
              current_line_only = false,
              hint_offset = 1,
            })
          end,
          'Hop 2-char anywhere backwards offset by 1',
          mode = { 'n', 'v', 'o' },
        },
      })

      do return end
      wk.register({
        ['f'] = {
          function()
            hop.hint_char1({
              direction = directions.AFTER_CURSOR,
              current_line_only = true,
            })
          end,
          'Hop 1-char current line forwards',
          mode = { 'n', 'v', 'o' },
        },
        ['F'] = {
          function()
            hop.hint_char1({
              direction = directions.BEFORE_CURSOR,
              current_line_only = true,
            })
          end,
          'Hop 1-char current line backwards',
          mode = { 'n', 'v', 'o' },
        },
        ['t'] = {
          function()
            hop.hint_char1({
              direction = directions.AFTER_CURSOR,
              current_line_only = true,
              hint_offset = -1
            })
          end,
          'Hop 1-char current line forwards offset by 1',
          mode = { 'n', 'v', 'o' },
        },
        ['T'] = {
          function()
            hop.hint_char1({
              direction = directions.BEFORE_CURSOR,
              current_line_only = true,
              hint_offset = 1,
            })
          end,
          'Hop 1-char current line backwards offset by 1',
          mode = { 'n', 'v', 'o' },
        },
        ['s'] = {
          function()
            hop.hint_char2({
              direction = directions.AFTER_CURSOR,
              current_line_only = false,
              hint_offset = 1,
            })
          end,
          'Hop 2-char current line forwards',
          mode = { 'n', 'v', 'o' },
        },
        ['S'] = {
          function()
            hop.hint_char2({
              direction = directions.BEFORE_CURSOR,
              current_line_only = false,
              hint_offset = 1,
            })
          end,
          'Hop 2-char current line backwards',
          mode = { 'n', 'v', 'o' },
        },
        ['w'] = {
          function()
            hop.hint_camel_case({
              direction = directions.AFTER_CURSOR,
              current_line_only = false
            })
          end,
          'Hop camelCase (forwards)',
          mode = { 'n', 'v', 'o' },
        },
        ['b'] = {
          function()
            hop.hint_camel_case({
              direction = directions.BEFORE_CURSOR,
              current_line_only = false
            })
          end,
          'Hop camelCase (backwards)',
          mode = { 'n', 'v', 'o' },
        },
        ['e'] = {
          function()
            hop.hint_camel_case({
              direction = directions.AFTER_CURSOR,
              hint_position = positions.END,
              current_line_only = false
            })
          end,
          'Hop camelCase (forwards, to end)',
          mode = { 'n', 'v', 'o' },
        },
        ['ge'] = {
          function()
            hop.hint_camel_case({
              direction = directions.BEFORE_CURSOR,
              hint_position = positions.END,
              current_line_only = false
            })
          end,
          'Hop camelCase (backwards, to end)',
        },
        ['/'] = {
          function()
            hop.hint_patterns({
              current_line_only = false
            })
          end,
          'Hop patterns',
        },
        ['j'] = {
          function()
            hop.hint_lines_skip_whitespace({
              direction = directions.AFTER_CURSOR,
            })
          end,
          'Hop lines (forwards)',
        },
        ['k'] = {
          function()
            hop.hint_lines_skip_whitespace({
              direction = directions.BEFORE_CURSOR,
            })
          end,
          'Hop lines (backwards)',
        },
        ['gj'] = {
          function()
            hop.hint_vertical({
              direction = directions.AFTER_CURSOR,
            })
          end,
          'Hop vertical (forwards)',
        },
        ['gk'] = {
          function()
            hop.hint_vertical({
              direction = directions.BEFORE_CURSOR,
            })
          end,
          'Hop vertical (backwards)',
        },
      }, { prefix = '<Leader>' })
    end,
  },
  {
    --     Old text                Command         New text
    -- ======================================================================
    -- surr*ound_words             ysiw)           (surround_words)
    -- *make strings               ys$"            "make strings"
    -- [delete ar*ound me!]        ds]             delete around me!
    -- remove <b>HTML t*ags</b>    dst             remove HTML tags
    -- 'change quot*es'            cs'"            "change quotes"
    -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    -- delete(functi*on calls)     dsf             function calls
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      keymaps = {
        insert = '<C-g>z',
        insert_line = '<C-g>Z',
        normal = 'yz',
        normal_cur = 'yzz',
        normal_line = 'yZ',
        normal_cur_line = 'yZZ',
        visual = 'Z',
        visual_line = 'gZ',
        delete = 'dz',
        change = 'cz',
        change_line = 'c>',
      },
    },
  },
  {
    -- `gc` - Toggles the region using linewise comment
    -- `gb` - Toggles the region using blockwise comment
    -- `gco` - Insert comment to the next line and enters INSERT mode
    -- `gcO` - Insert comment to the previous line and enters INSERT mode
    -- `gcA` - Insert comment to end of the current line and enters INSERT mode
    'numToStr/Comment.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {}
  },
  {
    "echasnovski/mini.ai",
    event = { 'BufReadPost', 'BufNewFile' },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)

      local i = {
        [" "] = "Whitespace",
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ["`"] = "Balanced `",
        ["("] = "Balanced (",
        [")"] = "Balanced ) including white-space",
        [">"] = "Balanced > including white-space",
        ["<lt>"] = "Balanced <",
        ["]"] = "Balanced ] including white-space",
        ["["] = "Balanced [",
        ["}"] = "Balanced } including white-space",
        ["{"] = "Balanced {",
        ["?"] = "User Prompt",
        ["_"] = "Underscore",
        ["a"] = "Argument",
        ["b"] = "Balanced ), ], }",
        ["c"] = "Class",
        ["f"] = "Function",
        ["o"] = "Block, conditional, loop",
        ["q"] = "Quote `, \", '",
        ["t"] = "Tag",
      }

      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(" including.*", "")
      end

      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs({ n = "Next", l = "Last" }) do
        i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
        a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        require("which-key").register({
          i = i,
          a = a,
          mode = { "o", "x" },
        })
      end
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    opts = {
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      enable_autocmd = false,
    },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },
}
