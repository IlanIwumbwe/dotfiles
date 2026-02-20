" --- BASIC SETTINGS ---
set number " Show line numbers
set relativenumber " Show relative numbers (great for moving around)
set autoindent
set smartindent
set tabstop=4 " Number of spaces a tab counts for
set shiftwidth=4 " Number of spaces to use for auto indenting
set expandtab " Convert tabs to spaces
set incsearch " Highlight matches as you type
set hlsearch " Keep search results highlighted

" --- FILE NAVIGATION ---
map <C-p> :Files<CR> " Opens Fuzzy Finder (Requires FZF plugin)
map <leader>e :Ex<CR> " Opens File Explorer (built-in)

" --- SHORTCUTS (COMMAND MAPPINGS) ---

" Save and Quit Commands:
" Use <leader> as the prefix key (often \ or ,)
" Saves the file without quitting
nmap <leader>w :w<CR> 
imap <leader>w <Esc>:w<CR>i

" Saves and quits the file
nmap <leader>q :wq<CR> 
imap <leader>Q <Esc>:wq<CR>

" Quick force quit (no save)
nmap <leader>Q :q!<CR> 

" --- MOVEMENT & WINDOWS ---
" Remap h, j, k, l to better keys if needed, but usually kept standard.

" Easier window navigation (Ctrl + h/j/k/l)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- GIT INTEGRATION ---
" Show git status in a new window (Requires fugitive.vim plugin)
nmap <leader>gs :Gstatus<CR>
" Diff the current file with the last commit
nmap <leader>gd :Gdiff<CR>
