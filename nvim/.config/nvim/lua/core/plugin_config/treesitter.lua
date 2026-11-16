require('nvim-treesitter').setup {
  ensure_installed = {"c", "ruby", "c++", "verilog", "rust", "lua", "vim", "python"},

  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  }
}
