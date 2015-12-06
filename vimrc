set nocompatible              " be VIMproved, required
filetype off                  " required
let mapleader = " "

" -------------
" Vundle config
" -------------

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'marijnh/tern_for_vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/syntastic'
Plugin 'killerx/vim-javascript-syntax'
Plugin 'groenewege/vim-less'
" Plugin 'evidens/vim-twig' discontinued. I should just use jinja highlighting
Plugin 'StanAngeloff/php.vim'
Plugin 'kylef/apiblueprint.vim'
Plugin 'mbbill/undotree'
Plugin 'junegunn/vim-peekaboo'
Plugin 'nathanaelkane/vim-indent-guides'

" -------------
" Color schemes
" -------------
Plugin 'morhetz/gruvbox'
Plugin 'tomasr/molokai'
Plugin 'zenorocha/dracula-theme', {'rtp': 'vim/'}

call vundle#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

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
iabbrev yy ✓

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

" enter a line above on shift-enter
nmap <S-Enter> O<Esc>j
" enter a line beneath on enter
nmap <CR> o<Esc>k
" move through long lines up
nnoremap k gk
" move through long lines down
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

" alias for reloading the conf
com! ReloadConfig :so $MYVIMRC

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