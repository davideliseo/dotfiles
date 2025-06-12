return {
  { 
    'marko-cerovac/material.nvim',
  },
  {
    'rebelot/kanagawa.nvim', -- kanagawa
  },
  {
    'catppuccin/nvim', -- catppuccin, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
    name = 'catppuccin',
  },
  {
    'neanias/everforest-nvim',
    config = function () 
      require('everforest').setup {
        background = 'hard', -- hard, medium, soft
        float_style = 'bright', -- bright, dim
      }
    end,
  },
  { 
    'bluz71/vim-nightfly-colors',
    name = 'nightfly',
  },
  {
    'shaunsingh/nord.nvim',
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function ()
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'projekt0n/github-nvim-theme',
  },
  {
    'sainnhe/gruvbox-material',
    config = false and function ()
      vim.g.gruvbox_material_background = 'soft' -- hard, medium, soft
      vim.g.gruvbox_material_foreground = 'material' -- material, mix, original
      vim.cmd.colorscheme 'everforest'
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
}
