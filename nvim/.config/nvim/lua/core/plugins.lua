-- Setup lazy.nvim
require("lazy").setup({
    'wbthomason/packer.nvim',
    'ellisonleao/gruvbox.nvim',
    'nvim-tree/nvim-tree.lua',
    'nvim-tree/nvim-web-devicons',
    'nvim-lualine/lualine.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
        'nvim-telescope/telescope.nvim',
        tag = "0.1.4",
        dependencies = {'nvim-lua/plenary.nvim'}
    },
})

