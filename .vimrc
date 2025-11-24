" ==============================================================================
" VIM PLUGIN MANAGEMENT
" ==============================================================================

call plug#begin('~/.vim/plugged')

" file explorer
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

" git integration
Plug 'airblade/vim-gitgutter'  " show git diff in sign column
Plug 'tpope/vim-fugitive'      " git commands in vim

" fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" text manipulation
Plug 'tpope/vim-surround'  " easily delete, change and add surroundings

" status line
Plug 'vim-airline/vim-airline'  " lean & mean status/tabline

" syntax & linting
Plug 'vim-syntastic/syntastic'  " syntax checking framework
Plug 'dense-analysis/ale'       " asynchronous linting engine

" language support
Plug 'rust-lang/rust.vim'                                        " rust
Plug 'leafgarland/typescript-vim'                                " typescript
Plug 'peitalin/vim-jsx-typescript'                               " jsx/tsx
Plug 'jparise/vim-graphql'                                       " graphql
Plug 'pangloss/vim-javascript'                                   " javascript
Plug 'maxmellon/vim-jsx-pretty'                                  " jsx
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" auto-completion
Plug 'ycm-core/YouCompleteMe'

" markdown
Plug 'JamshedVesuna/vim-markdown-preview'

" color scheme
Plug 'sjl/badwolf'

call plug#end()


" ==============================================================================
" COLOR SCHEME & APPEARANCE
" ==============================================================================

colorscheme badwolf
set background=dark

" line numbers
set nu              " number: display line numbers
set relativenumber  " show relative line numbers

" visual guides
set cursorline       " highlight current line
set colorcolumn=80   " show column at 80 characters

" cursor context
set so=7  " scrolloff: keep 7 lines visible above/below cursor when scrolling

" command line
set wildmenu      " enhanced command-line completion
set ruler         " show cursor position
set cmdheight=2   " set command window height to 2 lines

" matching brackets
set showmatch  " briefly jump to matching bracket when inserted


" ==============================================================================
" EDITOR BEHAVIOR
" ==============================================================================

" compatibility
set nocompatible  " don't preserve backward compatibility with vi

" backspace behavior
set backspace=eol,start,indent  " allow backspacing over everything in insert mode

" line wrapping
set whichwrap+=<,>,h,l,[,]  " allow cursor keys to wrap to prev/next line
set lbr                     " linebreak: wrap long lines at word boundaries

" performance
set lazyredraw  " don't redraw while executing macros

" special characters
set magic  " enable extended regex (special chars need backslash)


" ==============================================================================
" SEARCH SETTINGS
" ==============================================================================

set ignorecase  " case insensitive search
set smartcase   " override ignorecase if search contains uppercase
set hlsearch    " highlight search results
set incsearch   " show matches as you type

" clear search highlighting with ctrl-l (also redraws screen)
nnoremap <C-L> :nohl<CR><C-L>


" ==============================================================================
" INDENTATION & TABS
" ==============================================================================

" default settings (2 spaces)
set expandtab      " use spaces instead of tabs
set shiftwidth=2   " sw: number of spaces for auto-indent
set tabstop=4      " ts: number of spaces a tab counts for
set softtabstop=2  " sts: number of spaces for <tab> in insert mode

" auto-indenting
if has('filetype')
  syntax on
  filetype plugin indent on  " use filetype-specific indentation
else
  set ai  " autoindent: auto-indent
  set si  " smartindent: smart indent
endif


" ==============================================================================
" FILE HANDLING
" ==============================================================================

set nobackup    " nobackup: no backup before overwriting
set nowb        " nowritebackup: no backup after overwriting
set noswapfile  " don't create swap files
set confirm     " prompt for confirmation on dangerous operations


" ==============================================================================
" KEYBOARD & TIMING
" ==============================================================================

set noerrorbells  " no sound effects
set novisualbell  " no visual bell

" timeout settings (compatible with tmux)
set timeout timeoutlen=100
set ttimeout ttimeoutlen=100


" ==============================================================================
" NERDTREE CONFIGURATION
" ==============================================================================

let NERDTreeShowHidden=1  " show hidden files

" toggle nerdtree with ctrl-t
nmap <C-t> :NERDTreeToggle<CR>

" auto-close vim if nerdtree is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif


" ==============================================================================
" FZF CONFIGURATION
" ==============================================================================

" use ripgrep for file searching
let $FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow'
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

" keybindings
" fuzzy find files
nnoremap <C-p> :Files<CR>
" fuzzy search file contents
nnoremap <C-g> :Rg<CR>


" ==============================================================================
" YOUCOMPLETEME CONFIGURATION
" ==============================================================================

" Configure rust-analyzer with unique instance per Vim session
" Each Vim instance runs its own rust-analyzer with different settings

" Store features in script-local (Vim-instance-specific) variables
if !exists('s:rust_features')
    let s:rust_features = []
    let s:rust_no_default_features = v:false
endif

" Generate unique identifier for this Vim instance
let s:vim_instance_id = getpid()

" Configure YCM to use instance-specific rust-analyzer
let g:ycm_language_server = get(g:, 'ycm_language_server', {})

function! GetRustAnalyzerConfig()
    return {
        \ 'rust-analyzer': {
            \ 'cargo': {
                \ 'features': s:rust_features,
                \ 'noDefaultFeatures': s:rust_no_default_features,
            \ },
            \ 'procMacro': {
                \ 'enable': v:true
            \ }
        \ }
    \ }
endfunction

" Set up language server with instance-specific settings
let g:ycm_language_server['rust'] = {
    \ 'cmdline': ['rust-analyzer'],
    \ 'filetypes': ['rust'],
    \ 'project_root_files': ['Cargo.toml'],
    \ 'settings': GetRustAnalyzerConfig()
\ }

" Function to set rust-analyzer features
function! SetRustFeatures(features)
    " Parse comma-separated features
    let l:feature_list = split(a:features, ',')
    let l:feature_list = map(l:feature_list, 'trim(v:val)')

    " Update script-local variables
    let s:rust_features = l:feature_list
    let s:rust_no_default_features = v:true

    " Update the global config
    let g:ycm_language_server['rust']['settings'] = GetRustAnalyzerConfig()

    " Completely restart YCM to pick up new settings
    try
        execute 'YcmCompleter StopServer'
        sleep 300m
        execute 'YcmRestartServer'
        echo 'Rust features set to: [' . join(l:feature_list, ', ') . '] (Vim instance ' . s:vim_instance_id . ')'
    catch
        echo 'Error restarting YCM. Try :YcmRestartServer manually'
    endtry
endfunction

command! -nargs=1 RustFeatures call SetRustFeatures(<q-args>)

" Reset to default
function! ResetRustFeatures()
    let s:rust_features = []
    let s:rust_no_default_features = v:false

    let g:ycm_language_server['rust']['settings'] = GetRustAnalyzerConfig()

    try
        execute 'YcmCompleter StopServer'
        sleep 300m
        execute 'YcmRestartServer'
        echo 'Rust features reset (Vim instance ' . s:vim_instance_id . ')'
    catch
        echo 'Error restarting YCM. Try :YcmRestartServer manually'
    endtry
endfunction

command! RustFeaturesReset call ResetRustFeatures()

" Show current config
function! ShowRustFeatures()
    echo '=== Rust Features (Vim Instance ' . s:vim_instance_id . ') ==='

    if empty(s:rust_features)
        echo 'Features: [default]'
    else
        echo 'Features: [' . join(s:rust_features, ', ') . ']'
    endif
    echo 'No default features: ' . (s:rust_no_default_features ? 'true' : 'false')
    echo ''
    echo 'Active config:'
    echo string(g:ycm_language_server['rust']['settings'])
endfunction

command! RustFeaturesShow call ShowRustFeatures()

" =====

" python interpreter
let g:ycm_python_binary_path = "python"
let g:ycm_python_intepreter = "python"

" global extra conf, called upon starting vim
let g:ycm_global_ycm_extra_conf = expand('~/.vim/global_extra_conf.py')

" language server configuration
let g:ycm_language_server = [
  \ {
  \   'name': 'ty',
  \   'filetypes': [ 'python' ],
  \   'cmdline': [ 'ty', 'server' ],
  \   "rootPatterns": ["pyproject.toml", ".git"]
  \ }
  \ ]

" semantic triggers for auto-completion
let g:ycm_semantic_triggers = {
  \   "c" : ["->", "."],
  \   "cpp,cuda,objcpp" : ["->", ".", "::"],
  \   "cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go" : [".", "re!\w{2}"],
  \   "python" : [".", "re!\w{2}"],
  \ }

" logging and debugging
let g:ycm_server_log_level = 'debug'
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_file = '/tmp/ycm_log'

" performance
let g:ycm_disable_for_files_larger_than_kb=3000

" keybindings
let g:ycm_key_invoke_completion="<C-j>"
let g:ycm_key_list_stop_completion=["<CR>"]
let g:ycm_autoclose_preview_window_after_completion=1

nnoremap <leader>gq :YcmCompleter GetDoc<CR>
nnoremap <leader>ga :YcmCompleter GetType<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration<CR>

" rust support
let g:ycm_rust_toolchain_root = $HOME . '/.cargo'


" ==============================================================================
" ALE (ASYNCHRONOUS LINT ENGINE) CONFIGURATION
" ==============================================================================

let g:ale_linters_explicit = 1
let g:ale_linters = {
  \ 'python': ['ty', 'ruff'],
  \ }
let g:ale_python_pyrefly_executable = 'ty'


" ==============================================================================
" SYNTASTIC CONFIGURATION
" ==============================================================================

" disable for python (using ale instead)
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['python'] }


" ==============================================================================
" MARKDOWN CONFIGURATION
" ==============================================================================

let vim_markdown_preview_hotkey = '<F7>'
let vim_markdown_preview_github = 1  " use github-flavored markdown


" ==============================================================================
" JSX/TSX CONFIGURATION
" ==============================================================================

let g:vim_jsx_pretty_highlight_close_tag = 1


" ==============================================================================
" FILETYPE-SPECIFIC SETTINGS
" ==============================================================================

" python
let g:pyindent_open_paren = 'shiftwidth()'
au FileType python setl ts=4 sts=4 sw=4 tw=80  " tabstop, softtabstop, shiftwidth, textwidth

" javascript
au FileType javascript setl ts=2 sts=2 sw=2 tw=100

" go
au FileType go setl noexpandtab ts=8 sts=8 sw=8 tw=120

" shell scripts
au FileType sh setl ts=4 sts=4 sw=4 tw=100

" typescript
au FileType ts setl ts=2 sts=2 sw=2 tw=100

" json (prevent highlighting comments in red)
au FileType json syntax match Comment +\/\/.\+$+

" custom file type associations
au BufNewFile,BufRead Jenkinsfile setfiletype groovy
au BufNewFile,BufRead,BufEnter *.dockerfile setfiletype dockerfile
au BufNewFile,BufRead,BufEnter *.gohtml setfiletype html


" ==============================================================================
" CUSTOM KEYBINDINGS
" ==============================================================================

" window navigation (ctrl + hjkl)
nmap <C-j> <C-w><C-j>
nmap <C-k> <C-w><C-k>
nmap <C-h> <C-w><C-h>
nmap <C-l> <C-w><C-l>

" insert blank line below cursor with enter (normal mode)
nmap <Enter> o<ESC>

" move lines up/down (alt + jk)
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" workaround: map alt key in linux (make esc+key work as alt+key)
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw


" ==============================================================================
" VISUAL ENHANCEMENTS
" ==============================================================================

" highlight trailing whitespace in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/


" ==============================================================================
" AUTO-COMMANDS
" ==============================================================================

" trim trailing whitespace on save
au BufWritePre * %s/\s\+$//e

" remove carriage returns on save
au BufWritePre * %s/$//e
