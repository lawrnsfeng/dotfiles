call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
" Git diff in the sign column
Plug 'airblade/vim-gitgutter'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" mapping to easily delete, change and surround
Plug 'tpope/vim-surround'
" Git commands
Plug 'tpope/vim-fugitive'

" lean & mean status/tabline
Plug 'vim-airline/vim-airline'
" syntax checking hacks
" Plug 'vim-syntastic/syntastic'
Plug 'dense-analysis/ale'
" auto-completion
Plug 'ycm-core/YouCompleteMe'

" markdown preview
Plug 'JamshedVesuna/vim-markdown-preview'
" favorite theme
Plug 'sjl/badwolf'

" TS
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'jparise/vim-graphql'

" JS
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }


call plug#end()


colorscheme badwolf
set background=dark

" display line numbers on the left
set nu
" show relative live numbers
set relativenumber

" scrolloff determines the number of context lines above and below the cursor
set so=7
" better command-line completion
set wildmenu
" display the cursor position on the last line
set ruler
" set the command window height to 2 lines
set cmdheight=2

" allows backspacing over autoindent, line breaks and start of insert action
set backspace=eol,start,indent
" pressing left/right will move to the prev/next line after reaching the
" first/last character
set whichwrap+=<,>,h,l,[,]

" use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" highlight searches (use <C-L> to temporarily turn off highlighting)
set hlsearch
set incsearch
" map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" no redraw while excuting macros, registers and commands haven't typed
set lazyredraw
" characters having a special meaning need to be preceded with a backslash
set magic
" when a bracket is inserted, briefly jump to the matching one
set showmatch

" no sound effects
set noerrorbells
set novisualbell
" timeout on keycodes, a compatible settings with tmux
set timeout timeoutlen=100
set ttimeout ttimeoutlen=100

" default soft tab and indentation
set expandtab
set shiftwidth=2
set tabstop=4
set softtabstop=2

" wrap long lines
set lbr

" don't preserve backward compatibility with vi
:set nocompatible

if has('filetype')
" if a given file type has its own special auto-indentation rules, use them
  filetype plugin indent on
else
" turn on auto-indenting (if you turn off ':filetype plugin indent on')
  set ai

" make auto-indenting 'smarter' (if you turn off ':filetype plugin indent on')
  set si
endif

" highlight the current line and the linebreak column
set cursorline
set colorcolumn=80

" no backup before overwriting a file
set nobackup
set nowb
set noswapfile

" always prompt for dangerous operation
set confirm

" show hidden files in NERDTree
let NERDTreeShowHidden=1
" use <C-t> to toggle NERDTree
nmap <C-t> :NERDTreeToggle<CR>
" exit Vim if only NERDTree left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" highligh trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" dynamic window switching
nmap <C-j> <C-w><C-j>
nmap <C-k> <C-w><C-k>
nmap <C-h> <C-w><C-h>
nmap <C-l> <C-w><C-l>

" empower Enter
nmap <Enter> o<ESC>

" YouCompleteMe configuration
let g:ycm_python_binary_path="python3"
let g:ycm_semantic_triggers =  {
  \   "c" : ["->", "."],
  \   "cpp,cuda,objcpp" : ["->", ".", "::"],
  \   "cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go" : [".", "re!\w{2}"],
  \   "python" : [".", "re!\w{2}"],
  \ }
let g:ycm_disable_for_files_larger_than_kb=3000
let g:ycm_key_invoke_completion="<C-j>"
let g:ycm_key_list_stop_completion=["<CR>"]
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <leader>gq :YcmCompleter GetDoc<CR>
nnoremap <leader>ga :YcmCompleter GetType<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>

" autocmd for file types
" https://www.reddit.com/r/vim/comments/ka27x8/python_indents_by_8_when_it_should_be_4/
let g:pyindent_open_paren = 'shiftwidth()'
au FileType python setl ts=4 sts=4 sw=4 tw=80
au FileType javascript setl ts=2 sts=2 sw=2 tw=100
au FileType go setl noexpandtab ts=8 sts=8 sw=8 tw=120
au FileType sh setl ts=4 sts=4 sw=4 tw=100
au FileType ts setl ts=2 sts=2 sw=2 tw=100
au BufNewFile,BufRead Jenkinsfile setfiletype groovy
au BufNewFile,BufRead,BufEnter *.dockerfile setfiletype dockerfile
au BufNewFile,BufRead,BufEnter *.gohtml setfiletype html
" prevent highlighting comments in red for JSON
au FileType json syntax match Comment +\/\/.\+$+

" fzf configuration
let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow'
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>

" dynamic line shifting
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" a workaround to avail <A> in Linux, making it the same as <ESC>
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

" trim all trailing whitespaces
au BufWritePre * %s/\s\+$//e
au BufWritePre * %s/$//e

" vim markdown configuration
let vim_markdown_preview_hotkey = '<F7>'
let vim_markdown_preview_github = 1

let g:vim_jsx_pretty_highlight_close_tag = 1
