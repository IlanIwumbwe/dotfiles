return {
  -- Fuzzy finder for files/buffers/grep
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
    end,
  },

  -- Visual tab bar for buffers (the VSCode-tabs feel)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({})
      vim.keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>")
      vim.keymap.set("n", "<leader>bp", ":BufferLineCyclePrev<CR>")
      vim.keymap.set("n", "<leader>bd", ":bdelete<CR>")
    end,
  },

  -- Toggleable terminal (like VSCode's Ctrl-`)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "float",   -- try "horizontal" if you prefer a split
      })
    end,
  },

  -- A colorscheme so it doesn't look bare
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- File tree sidebar (optional, VSCode-explorer-like)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({})
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end,
  },
}
