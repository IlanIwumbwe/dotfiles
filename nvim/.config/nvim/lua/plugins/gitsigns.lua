return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    signs = {
      add          = { text = "┃" },
      change       = { text = "┃" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
      untracked    = { text = "┆" },
    },

    signcolumn = true,
    numhl = false,
    linehl = false,

    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          desc = desc,
        })
      end

      map("n", "]h", function()
        gs.nav_hunk("next")
      end, "Next Git change")

      map("n", "[h", function()
        gs.nav_hunk("prev")
      end, "Previous Git change")

      map("n", "<leader>hp", gs.preview_hunk, "Preview Git change")
      map("n", "<leader>hs", gs.stage_hunk, "Stage Git hunk")
      map("n", "<leader>hr", gs.reset_hunk, "Reset Git hunk")
      map("n", "<leader>hb", gs.blame_line, "Blame line")
    end,
  },
}

