return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      require("nvim-treesitter").setup({})
      require("nvim-treesitter").install({
        "bash", "c", "cpp", "lua", "python", "rust",
        "vim", "vimdoc", "query", "markdown", "markdown_inline",
      })

      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
          selection_modes = {
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "<c-v>",
          },
          include_surrounding_whitespace = false,
        },
        move = {
          enable = true,
          set_jumps = true,
        },
      })

      -- SELECT keymaps
      local sel = require("nvim-treesitter-textobjects.select")
      for _, map in ipairs({
        { { "x", "o" }, "af", "@function.outer" },
        { { "x", "o" }, "if", "@function.inner" },
        { { "x", "o" }, "ac", "@class.outer" },
        { { "x", "o" }, "ic", "@class.inner" },
        { { "x", "o" }, "aa", "@parameter.outer" },
        { { "x", "o" }, "ia", "@parameter.inner" },
      }) do
        vim.keymap.set(map[1], map[2], function()
          sel.select_textobject(map[3], "textobjects")
        end, { desc = "Select " .. map[3] })
      end

      -- MOVE keymaps
      local mv = require("nvim-treesitter-textobjects.move")
      for _, map in ipairs({
        { { "n", "x", "o" }, "]m", mv.goto_next_start, "@function.outer" },
        { { "n", "x", "o" }, "[m", mv.goto_previous_start, "@function.outer" },
        { { "n", "x", "o" }, "]]", mv.goto_next_start, "@class.outer" },
        { { "n", "x", "o" }, "[[", mv.goto_previous_start, "@class.outer" },
      }) do
        local modes, lhs, fn, query = map[1], map[2], map[3], map[4]
        vim.keymap.set(modes, lhs, function()
          fn(query, "textobjects")
        end, { desc = "Move to " .. query })
      end

      -- Highlighting, folding, indent — scoped per-buffer via FileType
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "bash", "c", "cpp", "lua", "python", "rust", "markdown" },
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if ok then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
