return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'c', 'cpp', 'lua', 'vim', 'vimdoc', 'query', -- Required langs
          'astro', 'bash', 'bibtex', 'css', 'csv', 'dart', 'diff', 'dockerfile',
          'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore',
          'graphql', 'html', 'javascript', 'json', 'jsonc', 'latex', 'php', 'prisma',
          'proto', 'python', 'regex', 'scss', 'sql', 'svelte', 'toml', 'typescript', 'tsx',
          'vue', 'xml', 'yaml',
        },
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'nvim-treesitter/playground' },
    },
  },
  {
    "dariuscorvus/tree-sitter-surrealdb.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "surrealdb",
    config = function()
      -- setup step
      require("tree-sitter-surrealdb").setup()
    end,
  }
}
