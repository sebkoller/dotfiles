set nocompatible              " be VIMproved, required
let mapleader = " "

if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug

  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif

call plug#begin('~/.vim/plugged')

  Plug 'junegunn/vim-plug',
          \ {'dir': '~/.vim/plugged/vim-plug/autoload'}

  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  Plug 'junegunn/vim-peekaboo'
  Plug 'bling/vim-airline'
  Plug 'kien/ctrlp.vim'
  Plug 'nathanaelkane/vim-indent-guides'

  Plug 'Valloric/YouCompleteMe', { 'do' : 'python2 ./install.py --clang-comleter' }
  Plug 'scrooloose/syntastic'
  Plug 'killerx/vim-javascript-syntax'
  Plug 'groenewege/vim-less', { 'for': 'less' }
  Plug 'marijnh/tern_for_vim', { 'do': 'npm install', 'for': 'javascript' }
  " Plug 'jelera/vim-javascript-syntax'
  Plug 'StanAngeloff/php.vim', { 'for': 'php' }
  Plug 'kylef/apiblueprint.vim'

  Plug 'Lokaltog/vim-easymotion'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'terryma/vim-multiple-cursors'
  " Plug 'evidens/vim-twig' discontinued. I should just use jinja highlighting
  " load promptline on demand via a function call (defined further down)
  Plug 'edkolev/promptline.vim', { 'on': [] }
  " -------------
  " Color schemes
  " -------------
  Plug 'morhetz/gruvbox'
  Plug 'tomasr/molokai'
  Plug 'zenorocha/dracula-theme', {'rtp': 'vim/'}

call plug#end()

" ----------------
" general settings
" ----------------

syntax on						" syntax highlighting
set number						" enable line numbers
colorscheme gruvbox
set ttimeoutlen=100				" updates modes in airline faster
set background=dark				" dark gruvbox version
set laststatus=2				" always show the statusline
set incsearch					" search as characters are entered
set hlsearch					" highlight all matches
set ignorecase					" search case insensitive
set smartcase					" search case sensitive if upper case letters are used
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set scrolloff=5
set splitbelow					" open horizontal split windows below
set splitright					" open vertical splits to the right
set autoread					" load disk changes if there are no unsaved changes
set ttyfast
set lazyredraw

" -----------------
" terminal specific
" -----------------
set mouse=a						" mouse navigation
set ttymouse=sgr				" properly recognize mouse clicks

" -----------------------
" hard to type characters
" -----------------------
iabbrev >> →
iabbrev << ←
iabbrev ^^ ↑
iabbrev VV ↓
iabbrev aa λ

" ---------------
" custom key maps
" ---------------

" with leader key
nnoremap <silent><leader>h :nohlsearch<CR>
nnoremap <silent><leader>n :NERDTreeToggle<CR>
nnoremap <silent><leader>r :set relativenumber!<cr>
nnoremap <silent><leader>u :UndotreeToggle<CR>
nnoremap <leader>c :%s///gn <CR>
set pastetoggle=<leader>p

" yield to the end of line
noremap Y y$
" move through long lines up and down
nnoremap k gk
nnoremap j gj
" auto close brackets on open bracket - enter
inoremap {<CR>  {<CR>}<Esc>O

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" NERDTree
let NERDTreeIgnore = ['\.pyc$']  " ignore compiled python files

" You complete me <3
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 8
let g:syntastic_ignore_files = ['*.isml']					" doesnt seem to work
let g:syntastic_html_checkers=['']							" disable html checkers
let g:syntastic_python_flake8_args='--ignore=W191,E501'		" allow tabs & ignore line lengths


" Demandware syntax highlighting
au BufEnter *.isml set filetype=html
au BufRead,BufNewFile *.ds set filetype=dwscript
au! Syntax dwscript source ~/.vim/bundle/vim-javascript-syntax/syntax/dwscript.vim


let g:airline_powerline_fonts=1
if has("gui_running")
  if has("gui_macvim")
    set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline:h11
  else
	set guifont=Meslo\ LG\ S\ for\ Powerline\ 9.5
  endif
endif


" UTF-8
set encoding=utf-8
setglobal fileencoding=utf-8
set nobomb
set termencoding=utf-8
set fileencodings=utf-8

" alias for JSON formatting via python
com! FormatJSON %!python -m json.tool

" alias for reloading the config
com! ReloadConfig :so $MYVIMRC | AirlineRefresh

" Allow saving of files as sudo when I forgot to start vim using sudo.
com! SudoWrite %!sudo tee > /dev/null %


autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" remove trailing whitespaces on :w, save cursor position
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun

" highlight the cursorline for the active window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" set a dedicated directory for the undo history
if has('persistent_undo')
  let undo_directory = expand('$HOME/.vim/undo')
  call system('mkdir ' . undo_directory)
  set undofile
  let &undodir = undo_directory
endif

" Generate a shell prompt that uses the same theme as the vim airline
com! PromptlineBuilder :call <SID>PromptlineBuilder()
fun! <SID>PromptlineBuilder()
  call plug#load('promptline.vim')
  let g:promptline_preset = {
    \'a' : [promptline#slices#host({ 'only_if_ssh': 1 }) ],
    \'b' : [promptline#slices#user() ],
    \'c' : [promptline#slices#cwd({ 'dir_limit': 2 }) ],
    \'y' : [promptline#slices#vcs_branch() ],
    \'warn' : [promptline#slices#last_exit_code() ]}
  let dir = '~/.goodies/promptline/'
  let file = 'shell_prompt.sh'
  let theme = 'airline'
  call system('mkdir -p ' . dir)
  execute 'PromptlineSnapshot! ' . dir . file . ' ' . theme
  echo 'Created ' . file . ' in ' . dir . ' using the '. theme . ' theme'
endfun
