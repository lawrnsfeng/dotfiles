call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'airblade/vim-gitgutter'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'
Plug 'vim-syntastic/syntastic'
Plug 'ycm-core/YouCompleteMe'

Plug 'JamshedVesuna/vim-markdown-preview'

Plug 'sjl/badwolf'

call plug#end()


colorscheme badwolf
set background=dark

set nu
set relativenumber

set so=7
set wildmenu
set ruler
set cmdheight=2

set backspace=eol,start,indent
set whichwrap+=<,>,[,]

set ignorecase
set smartcase

set hlsearch
set incsearch

set lazyredraw
set magic
set showmatch

set noerrorbells
set timeout timeoutlen=100
set ttimeout ttimeoutlen=100
set novisualbell

set expandtab
set shiftwidth=2
set tabstop=4
set softtabstop=2

set lbr

set ai
set si

set cursorline
set colorcolumn=80

set nobackup
set nowb
set noswapfile

" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
"     \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
nmap <C-t> :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

nmap <C-j> <C-w><C-j>
nmap <C-k> <C-w><C-k>
nmap <C-h> <C-w><C-h>
nmap <C-l> <C-w><C-l>

nmap <Enter> o<ESC>

let g:ycm_python_binary_path="python3"
let g:ycm_semantic_triggers =  {
  \   "c" : ["->", "."],
  \   "cpp,cuda,objcpp" : ["->", ".", "::"],
  \   "cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go" : [".", "re!\w{2}"],
  \   "python" : [".", "re!\w{2}"],
  \ }
let g:ycm_disable_for_files_larger_than_kb=3000
let g:ycm_key_invoke_completion="<C-j>"
nnoremap <leader>? :YcmCompleter GetDoc<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>

autocmd FileType python setl ts=4 sts=4 sw=4 tw=80
autocmd FileType javascript setl ts=2 sts=2 sw=2 tw=100
autocmd BufNewFile,BufRead Jenkinsfile setfiletype groovy

let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow'
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>
set confirm

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

autocmd BufWritePre * %s/\s\+$//e
