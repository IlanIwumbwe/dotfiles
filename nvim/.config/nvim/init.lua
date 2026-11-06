-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic sane settings
vim.g.mapleader = " "          -- spacebar as leader key
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

require("lazy").setup("plugins")

vim.keymap.set('n', '<leader>n', ':bnext<CR>')
vim.keymap.set('n', '<leader>p', ':bprevious<CR>')
vim.keymap.set('n', '<C-x>', ':bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<Esc>', ':noh<CR><Esc>', { desc = 'No highlight' })

-- Copy the unnamed register to tmux after yanking text.
vim.keymap.set("n", "<leader>ty", function()
  local output = vim.fn.system({ "tmux", "load-buffer", "-" }, vim.fn.getreg('"'))
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not copy to tmux: " .. output, vim.log.levels.ERROR)
    return
  end
  vim.notify("Copied to tmux paste buffer")
end, { desc = "Copy yanked text to tmux" })

vim.keymap.set("x", "*", function()
  -- Yank the visual selection into register z
  vim.cmd('normal! "zy')

  -- Escape special search characters
  local text = vim.fn.escape(vim.fn.getreg("z"), [[\/]])
  
  -- Search for the exact selected text
  vim.fn.setreg("/", [[\V]] .. text)
  vim.opt.hlsearch = true
end, { desc = "Search visual selection" })


vim.api.nvim_set_hl(0, "LineNr", {
  fg = "#ffff00",
})

vim.api.nvim_set_hl(0, "CursorLineNr", {
  fg = "#ffd700",
  bold = true,
})

vim.filetype.add({
  extension = {
    mds = "verilog"
  },
})

-- Neovim session management

local session_dir = vim.fn.stdpath("state") .. "/sessions"
vim.fn.mkdir(session_dir, "p")

local startup_cwd = vim.fn.getcwd()

local session_path = session_dir .. "/" .. vim.fn.sha256(startup_cwd) .. ".vim"

local restoring = true
local saving = false

local auto_restore = vim.fn.argc() == 0

local function save_session()
    if restoring or saving then
        return
    end

    saving = true

    local ok, err = pcall(
        function() vim.cmd.mksession({bang=true,args={session_path},})
        end
    )

    saving = false

    if not ok then
        vim.notify(
            "Failed to save nvim session: " .. tostring(err),
            vim.log.levels.WARN
        )
    end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if auto_restore and vim.fn.filereadable(session_path) == 1 then
      local ok, err = pcall(function()
        vim.cmd.source(vim.fn.fnameescape(session_path))
      end)

      if not ok then
        vim.notify(
          "Failed to restore Neovim session: " .. tostring(err),
          vim.log.levels.WARN
        )
      end
    end

    restoring = false

  end,
})

-- ============================================================
-- Save on Layout Changes
-- ============================================================

-- Debounce rapid events to avoid excessive disk writes
local save_timer = vim.uv.new_timer()

local function schedule_save()
  if restoring then
    return
  end

  save_timer:stop()
  save_timer:start(
    500,
    0,
    vim.schedule_wrap(save_session)
  )
end

vim.api.nvim_create_autocmd({
  "TabEnter",
  "TabClosed",
  "WinEnter",
  "BufEnter",
  "BufDelete",
}, {
  callback = schedule_save,
})

-- ============================================================
-- Periodic Save (Every 30 Seconds)
-- ============================================================

local periodic_timer = vim.uv.new_timer()

periodic_timer:start(
  30000,
  30000,
  vim.schedule_wrap(save_session)
)

-- ============================================================
-- Save on Exit
-- ============================================================

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    -- Cancel pending delayed saves
    save_timer:stop()
    periodic_timer:stop()

    -- Save final session synchronously
    save_session()

    -- Clean up timers
    save_timer:close()
    periodic_timer:close()
  end,
})

-- ============================================================
-- Manual Commands
-- ============================================================

vim.api.nvim_create_user_command("SessionSave", function()
  save_session()
end, {})

vim.api.nvim_create_user_command("SessionPath", function()
  print(session_path)
end, {})   
