-- Basic sane settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.splitright = true      -- vertical splits open to the right
vim.opt.splitbelow = true      -- horizontal splits open below
vim.opt.foldlevel = 99
vim.g.clipboard = "osc52"
-- Toggle terminal at the bottom

vim.keymap.set('n', '<leader>n', ':bnext<CR>')
vim.keymap.set('n', '<leader>p', ':bprevious<CR>')
vim.keymap.set('n', '<C-x>', ':bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { desc = 'No highlight' })

vim.keymap.set('n', '<leader>t', function()
    vim.cmd.new()
    -- Toggle terminal at the bottom
    vim.cmd.term()
    vim.cmd.wincmd('J')
    vim.api.nvim_win_set_height(0, 15)
end)

-- Copy the unnamed register to tmux after yanking text.
vim.keymap.set("n", "<leader>ty", function()
  local output = vim.fn.system({ "tmux", "load-buffer", "-" }, vim.fn.getreg('"'))
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not copy to tmux: " .. output, vim.log.levels.ERROR)
    return
  end
  vim.notify("Copied to tmux paste buffer")
end, { desc = "Copy yanked text to tmux" })

-- Toggle terminal at the bottom
local term = { buf = nil, win = nil }

local function toggle_term()
  -- Visible: hide it
  if term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_hide(term.win)
    term.win = nil
    return
  end

  -- Hidden: reopen at the bottom
  vim.cmd('botright 15split')
  term.win = vim.api.nvim_get_current_win()

  if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    vim.api.nvim_win_set_buf(term.win, term.buf)
  else
    vim.cmd('terminal')
    term.buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd('startinsert')
end

vim.keymap.set({ 'n', 't' }, '<C-t>', toggle_term, { desc = 'Toggle terminal' })
