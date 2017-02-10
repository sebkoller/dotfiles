set nocompatible              " be VIMproved, required
let mapleader = " "

if has('vim_starting')
  set rtp+=~/.vim/plugged/vim-plug

  if !isdirectory(expand('~/.vim/plugged/vim-plug'))
    echo 'installing vim-plug...'
    call system('mkdir -p ~/.vim/plugged/vim-plug')
    call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  end
endif


call plug#begin('~/.vim/plugged')

  Plug 'junegunn/vim-plug', {'dir': '~/.vim/plugged/vim-plug/autoload'}

  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  Plug 'junegunn/vim-peekaboo'
  Plug 'vim-airline/vim-airline'
  Plug 'kien/ctrlp.vim'

  Plug 'Valloric/YouCompleteMe', { 'do' : './install.py --clang-completer' }
  Plug 'w0rp/ale'
  Plug 'killerx/vim-javascript-syntax', { 'as': 'vim-dwscript-syntax', 'for': 'dwscript' }
  Plug 'othree/yajs.vim', { 'for': 'javascript' }
  Plug 'groenewege/vim-less', { 'for': 'less' }
  Plug 'marijnh/tern_for_vim', { 'do': 'npm install', 'for': 'javascript' }
  Plug 'StanAngeloff/php.vim', { 'for': 'php' }
  Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
  Plug 'kylef/apiblueprint.vim'
  Plug 'vim-scripts/closetag.vim'
  Plug 'hynek/vim-python-pep8-indent'
  Plug 'mattn/emmet-vim', { 'for': ['html', 'php'] }

  Plug 'Lokaltog/vim-easymotion'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'wellle/targets.vim'
  Plug 'unblevable/quick-scope'
  Plug 'Glench/Vim-Jinja2-Syntax'
  " load promptline on demand via a function call (defined further down)
  Plug 'edkolev/promptline.vim', { 'on': [] }
  Plug 'mileszs/ack.vim'
  Plug 'junegunn/vim-easy-align'
  "" -------------
  "" Color schemes
  "" -------------
  Plug 'morhetz/gruvbox'
  Plug 'crusoexia/vim-monokai'
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
set vb t_vb=					" disable visual bell
autocmd GUIEnter * set vb t_vb= " disable visual bell in gvim
set t_Co=256					" color fix for tmux
set noshowmode					" don't show the mode as Airline is doing it

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
iabbrev xx ✘

" ---------------
" custom key maps
" ---------------

" with leader key
nnoremap <silent><leader>s :nohlsearch<CR>
nnoremap <silent><leader>n :NERDTreeToggle<CR>
nnoremap <silent><leader>r :set relativenumber!<cr>
nnoremap <silent><leader>u :UndotreeToggle<CR>
" count the last search
nnoremap <leader>c :%s///gn <CR>
" make with quickfix on errors
nnoremap <leader>m :silent make!\|redraw!\|cw<CR>
" yield the files content
nnoremap <silent><leader>y :%y+<CR>

" yield to the end of line
noremap Y y$
" move through long lines up and down
nnoremap k gk
nnoremap j gj
" auto close brackets on open bracket - enter
inoremap {<CR>  {<CR>}<Esc>O

" search for visual selection
vnoremap // y/<C-R>"<CR>

nnoremap <leader>f :Ack!<SPACE>""<LEFT>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


let file_system = system("df -P -T ./ | tail -n +2 | awk '{printf $2}'")

" don't use ag for ctrlp on remote file systems, as indexes should be cached
if executable('ag') && file_system != 'fuse.sshfs'
  let g:ackprg = 'ag --vimgrep'
  let g:ackhighlight = 1

   " use ag in CtrlP for listing files
  let g:ctrlp_user_command = 'ag -p ~/.agignore %s -l --nocolor --nogroup --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif


let g:EasyMotion_smartcase = 1
let NERDTreeIgnore = ['\.pyc$']  " ignore compiled python files

" quick scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" You complete me <3
let g:ycm_autoclose_preview_window_after_insertion = 1


" A.L.E.
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_use_global = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)


" Demandware syntax highlighting
au BufRead,BufNewFile *.isml set filetype=html
au BufRead,BufNewFile *.ds set filetype=dwscript
" au! Syntax dwscript source ~/.vim/plugged/vim-dwscript-syntax/syntax/dwscript.vim
"
au BufRead,BufNewFile *.twig set filetype=jinja


iabbrev funciton function
iabbrev functiton function
iabbrev fucntion function
iabbrev funtion function
iabbrev erturn return
iabbrev retunr return
iabbrev reutrn return
iabbrev reutn return
iabbrev queyr query
iabbrev htis this
iabbrev foreahc foreach
iabbrev forech foreach


"
" ---------------------
"  working with buffers
" ---------------------

set hidden							" don't force changes to be saved
nmap <leader>t :enew<cr>|			" open a new buffer
nmap <leader>l :bnext<CR>|			" Move to the next buffer
nmap <leader>h :bprevious<CR>|		" Move to the previous buffer
nmap <leader>bq :bp <BAR> bd #<CR>| " Close the current buffer and move to the previous one
nmap <leader>bd :bp <BAR> bd #<CR>| " Close the current buffer and move to the previous one
nmap <leader>bl :ls<CR>|			" Show all open buffers and their status

" hide quickfix buffers when cycling through buffers
augroup qf
  autocmd!
  autocmd FileType qf set nobuflisted
augroup END



let g:airline#extensions#tabline#enabled = 1		" Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t'	" Show just the filename
let g:airline#extensions#tabline#show_tabs = 1

if empty($SSH_TTY)
  let g:airline_powerline_fonts=1
endif

if has("gui_running")
  if has("gui_macvim")
    set guifont=Meslo\ LG\ S\ Regular\ for\ Powerline:h11
  else
    set guifont=Meslo\ LG\ S\ for\ Powerline\ 9.5
  endif
else
  if $PLATFORM == 'Darwin'
    set termguicolors
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


autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
set completeopt=longest,menuone
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

" set a dedicated directory for the backup files
let backup_directory = expand('$HOME/.vim/backup')
call system('mkdir ' . backup_directory)
let &backupdir = backup_directory . '//'
let &directory = backup_directory . '//'

" Generate a shell prompt with the same colorscheme as vim airline
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
  if !empty($SSH_TTY)
    let g:promptline_powerline_symbols = 0
  endif
  call system('mkdir -p ' . dir)
  execute 'PromptlineSnapshot! ' . dir . file . ' ' . theme
  echo 'Created ' . file . ' in ' . dir . ' using the '. theme . ' theme'
endfun


" Display spacemacs-like window number
" with leader mapping to switch splits
let g:airline_inactive_collapse=0
let g:airline_mode_map = { '__' : ' ' }
let i = 1
while i <= 9
  execute 'nnoremap <silent><leader>' . i . ' :' . i . 'wincmd w<CR>'
  let i = i + 1
endwhile

function! WindowNumber()
  let page=tabpagewinnr(tabpagenr())
  let numbers=['➊','➋','➌','➍','➎','➏','➐','➑','➒']
  return numbers[page-1]
endfunction
call airline#parts#define_function('windownumber', 'WindowNumber')

function! AirlineInit()
  let g:airline_section_a = airline#section#create_left(['windownumber', 'mode', 'crypt', 'paste', 'spell', 'capslock', 'iminsert'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()
