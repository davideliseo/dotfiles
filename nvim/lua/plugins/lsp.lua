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
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
    },
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
          { name = 'vim-dadbod-completion' },
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
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
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

      lsp_zero.on_attach(function(_, bufnr)
        local telescope = require('telescope.builtin')
        require('which-key').register({
          ['<Leader>l'] = {
            name = 'lsp',
            ['i'] = { vim.lsp.buf.hover, 'Hover symbol definition under cursor' },
            ['r'] = { vim.lsp.buf.rename, 'Rename all references to symbol under cursor' },
            ['f'] = {
              function()
                vim.lsp.buf.format({
                  filter = function(client) return client.name ~= "tsserver" end,
                })
              end,
              'Format buffer using LSP server',
            },
            ['a'] = { function()
              vim.lsp.buf.code_action({
                filter = function(action)
                  return true
                end,
              })
            end, 'Display code actions available' },
            ['o'] = { telescope.lsp_document_symbols, 'LSP document symbols' },
            ['O'] = { telescope.lsp_dynamic_workspace_symbols, 'LSP workspace symbols' },
            ['d'] = { telescope.diagnostics, 'LSP diagnostics' },
            ['g'] = {
              name = 'goto',
              ['d'] = { vim.lsp.buf.definition, 'Jumps to definition of symbol under cursor' },
              ['D'] = { vim.lsp.buf.declaration, 'Jumps to declaration of symbol under cursor' },
              ['i'] = { vim.lsp.buf.implementation, 'Lists all implementations of symbol under cursor' },
              ['t'] = { vim.lsp.buf.type_definition, 'Jumps to definition of type symbol under cursor' },
              ['r'] = { telescope.lsp_references, 'LSP references' },
              ['s'] = { vim.lsp.buf.signature_help, 'Signature information of symbol under cursor' },
            },
          },
        }, { buffer = bufnr })
      end)

      -- NOTE: dartls is configured by akinsho/flutter-tools.nvim
      -- require('lspconfig').dartls.setup({})

      -- require('mason').setup({
      --   registries = {
      --     "github:mason-org/mason-registry",
      --     "github:Crashdummyy/mason-registry",
      --   },
      -- })
      --
      require('mason-lspconfig').setup({
        ensure_installed = { 'astro', 'tailwindcss', 'prismals', 'rust_analyzer' },
        handlers = {
          lsp_zero.default_setup,
          -- function(server_name)
          --   if server_name == "tsserver" then
          --     server_name = "ts_ls"
          --   end
          --   local capabilities = require("cmp_nvim_lsp").default_capabilities()
          --   require("lspconfig")[server_name].setup({
          --     capabilities = capabilities,
          --   })
          -- end,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
          angularls = function()
            require('lspconfig').angularls.setup({
              filetypes = { "angular", "typescript", "html", "typescriptreact", "typescript.tsx" }
            })
          end,
        },
      })

      require('lspconfig').rust_analyzer.setup {
        settings = {
          ["rust-analyzer"] = {
            rustfmt = {
              extraArgs = { "+nightly", },
            },
          }
        }
      }

      require('lspconfig').ts_ls.setup {
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "shortest",
            autoImportFileExcludePatterns = { "@radix-ui", "^next/router$", "next/dist", "^lucide-react/dist/lucide-react.suffixed$" }
          }
        }
      }

      require('lspconfig').tailwindcss.setup({
        filetypes = {
          "angular", "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango",
          "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html",
          "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor",
          "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact",
          "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte",
        },
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              invalidVariant = "error",
              recommendedVariantOrder = "warning"
            },
            validate = true,
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)",  "(?:'|\"|`)([^']*)(?:'|\"|`)" }
              },
            },
          },
        },
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          -- prettierd has a bug where it won't find prettier-plugin-tailwindcss installed.
          -- Running :exec '!' . stdpath('data') . '/mason/bin/prettierd stop' solves this issue.
          "prettierd",
        },
        automatic_installation = true,
        handlers = {},
      })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {},
        debug = true,
      })
    end,
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
          vim.api.nvim_set_hl(0, 'FlutterWidgetGuides', { link = 'Whitespace' })

          local wk = require('which-key')
          local commands = require('flutter-tools.commands');
          local function flutter_action(kind)
            vim.lsp.buf.code_action({
              apply = true,
              filter = function(action) return action.kind == kind end,
            })
          end

          wk.register({
            ['<Leader>l'] = {
              name = 'lsp',
              ['p'] = {
                require('telescope').extensions.flutter.commands,
                'Flutter LSP commands',
              },
              ['s'] = {
                name = 'flutter',
                ['r'] = { commands.reload, 'Flutter: Hot reload' },
                ['R'] = { commands.restart, 'Flutter: Hot restart' },
                ['w'] = { commands.run, 'Flutter: Run' },
                ['q'] = { commands.quit, 'Flutter: Quit' },
                ['a'] = {
                  name = 'flutter-actions',
                  ['x'] = {
                    function() flutter_action('source.fixAll') end,
                    'Flutter: Fix all',
                  },
                  ['e'] = {
                    function() flutter_action('refactor.extract') end,
                    'Flutter: Extract',
                  },
                  ['d'] = {
                    function() flutter_action('refactor.flutter.removeWidget') end,
                    'Flutter: Remove widget',
                  },
                  ['c'] = {
                    function() flutter_action('refactor.flutter.wrap.container') end,
                    'Flutter: Wrap with container',
                  },
                  ['h'] = {
                    function() flutter_action('refactor.flutter.wrap.row') end,
                    'Flutter: Wrap with row',
                  },
                  ['v'] = {
                    function() flutter_action('refactor.flutter.wrap.column') end,
                    'Flutter: Wrap with column',
                  },
                  ['p'] = {
                    function() flutter_action('refactor.flutter.wrap.padding') end,
                    'Flutter: Wrap with padding',
                  },
                },
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
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      file_watching = "off",
      choose_target = nil,
      ignore_target = nil,
      broad_search = true,
      lock_target = false,
      config = {
        filetypes = { "cs" },
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "fullSolution",
            dotnet_compiler_diagnostics_scope = "fullSolution",
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ["csharp|formatting"] = {
            csharp_indent_case_contents = true,
            csharp_indent_case_contents_when_block = false,

          }
        },
      },
    },
    keys = {
      {
        "<Leader>lD",
        function()
          ---@param lines string[]?
          ---@param lnum integer
          ---@param col integer
          ---@param offset_encoding string
          ---@return integer
          local function line_byte_from_position(lines, lnum, col, offset_encoding)
            if not lines or offset_encoding == "utf-8" then
              return col
            end

            local line = lines[lnum + 1]
            local ok, result = pcall(vim.str_byteindex, line, col, offset_encoding == "utf-16")
            if ok then
              return result --- @type integer
            end

            return col
          end

          ---@param severity lsp.DiagnosticSeverity
          local function severity_lsp_to_vim(severity)
            if type(severity) == "string" then
              severity = vim.lsp.protocol.DiagnosticSeverity[severity] --- @type integer
            end
            return severity
          end

          --- @param diagnostic lsp.Diagnostic
          --- @param client_id integer
          --- @return table?
          local function tags_lsp_to_vim(diagnostic, client_id)
            local tags ---@type table?
            for _, tag in ipairs(diagnostic.tags or {}) do
              if tag == vim.lsp.protocol.DiagnosticTag.Unnecessary then
                tags = tags or {}
                tags.unnecessary = true
              elseif tag == vim.lsp.protocol.DiagnosticTag.Deprecated then
                tags = tags or {}
                tags.deprecated = true
              else
                vim.lsp.log.info(string.format("Unknown DiagnosticTag %d from LSP client %d", tag, client_id))
              end
            end
            return tags
          end

          ---@param bufnr integer
          ---@return string[]?
          local function get_buf_lines(bufnr)
            if vim.api.nvim_buf_is_loaded(bufnr) then
              return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            end

            local filename = vim.api.nvim_buf_get_name(bufnr)
            local f = io.open(filename)
            if not f then
              return
            end

            local content = f:read("*a")
            if not content then
              -- Some LSP servers report diagnostics at a directory level, in which case
              -- io.read() returns nil
              f:close()
              return
            end

            local lines = vim.split(content, "\n")
            f:close()
            return lines
          end

          ---@param diagnostics lsp.Diagnostic[]
          ---@param bufnr integer
          ---@param client_id integer
          ---@return vim.Diagnostic[]
          local function diagnostic_lsp_to_vim(diagnostics, bufnr, client_id)
            local buf_lines = get_buf_lines(bufnr)
            local client = vim.lsp.get_client_by_id(client_id)
            local offset_encoding = client and client.offset_encoding or "utf-16"
            --- @param diagnostic lsp.Diagnostic
            --- @return vim.Diagnostic
            return vim.tbl_map(function(diagnostic)
              local start = diagnostic.range.start
              local _end = diagnostic.range["end"]
              local message = diagnostic.message
              if type(message) ~= "string" then
                vim.notify_once(
                  string.format("Unsupported Markup message from LSP client %d", client_id),
                  vim.lsp.log_levels.ERROR
                )
                message = diagnostic.message.value
              end
              --- @type vim.Diagnostic
              return {
                lnum = start.line,
                col = line_byte_from_position(buf_lines, start.line, start.character, offset_encoding),
                end_lnum = _end.line,
                end_col = line_byte_from_position(buf_lines, _end.line, _end.character, offset_encoding),
                severity = severity_lsp_to_vim(diagnostic.severity),
                message = message,
                source = diagnostic.source,
                code = diagnostic.code,
                _tags = tags_lsp_to_vim(diagnostic, client_id),
                user_data = {
                  lsp = diagnostic,
                },
              }
            end, diagnostics)
          end

          local client = vim.lsp.get_clients()[1]
          client.request("workspace/diagnostic", { previousResultIds = {} }, function(err, result, context, config)
            local ns = vim.lsp.diagnostic.get_namespace(client.id)

            local function find_buf_or_make_unlisted(file_name)
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_get_name(buf) == file_name then
                  return buf
                end
              end

              local buf = vim.api.nvim_create_buf(false, false)
              vim.api.nvim_buf_set_name(buf, file_name)
              return buf
            end

            for _, per_file_diags in ipairs(result.items) do
              local filename = string.gsub(per_file_diags.uri, "file://", "")
              local buf = find_buf_or_make_unlisted(filename)

              vim.diagnostic.set(ns, buf, diagnostic_lsp_to_vim(per_file_diags.items, buf, context.client_id))
            end
          end)
        end
      }
    }
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
    lazy = false,
    config = function()
      require("easy-dotnet").setup()
    end
  },
}
