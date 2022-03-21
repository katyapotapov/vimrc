"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Appearance and sound
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" terminator set tab title
autocmd BufEnter * let &titlestring = ' ' . expand("%:p")
set title
set titleold=

" Colorscheme
" colorscheme jellybeans
packadd! dracula
syntax enable
colorscheme dracula

" Add a bit extra margin to the left
set foldcolumn=1

" Transparency
hi Normal guibg=NONE ctermbg=NONE

" No audible or visual bell on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indents
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 120 characters (changed from 500)
set lbr
set tw=120

" Autoindent - apply indentation of current line to next
set ai

" Smartindent - indents react to syntax of the code you're editing, especially for C
set si

" Wrap lines
set wrap

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Searching
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ignore case when searching
set ignorecase

" ...unless a pattern contains an uppercase
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving through/between files and windows
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Relative numbering makes jumping faster
:set number relativenumber

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Brackets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show matching brackets when text indicator is over them
set showmatch 

" How many tenths of a second to blink when matching brackets
set mat=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Permissions and encryption
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set secure encryption method
" set cm=blowfish2

" :W sudo saves the file 
" (useful when you forgot that you needed sudo to edit a file)
command W w !sudo tee % > /dev/null

" Set to auto read when a file is changed from the outside
set autoread

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Folds
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto folds
set foldmethod=syntax
set foldlevelstart=1

let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Other
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcut for datetime string - useful for journaling and note-taking
:nnoremap <F3> "=strftime("%c")<CR>P
:inoremap <F3> <C-R>=strftime("%c")<CR>

" Don't redraw while executing macros (good performance config)
set lazyredraw 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
" use command :PlugInstall to install
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

Plug 'ervandew/supertab'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'junegunn/fzf'

" support for expanding abbreviations (nice for frontend)
" for HTML:
  " you can type elements (div+p>li)
  " implicit tag names (.wrap)
  " starter code (html:5)
  " and then expand with Ctrl+y+,
Plug 'mattn/emmet-vim'

call plug#end()

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn off spellcheck in pandoc syntax
let g:pandoc#spell#enabled = 0

" add fzf (fuzzy finder)
source /usr/share/doc/fzf/examples/fzf.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Useful shortcuts you may have forgotten
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" :Ex - explore filesystem in current buffer
" :Sex - explore filesystem in split tab
" :Vex - explore filesystem in vert split tab
