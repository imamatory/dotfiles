lua require('init')

set nocompatible

let $PATH = $PATH . ':' . expand('~/.local/bin') . ':' . '/usr/local/bin/'
let $LANG = 'en'

call plug#begin('~/.local/share/nvim/plugged')


" coc
Plug 'neoclide/coc.nvim', { 'branch': 'master', 'do': { -> coc#util#install()} }

nnoremap <silent> <leader>a :<C-u>CocList -A --normal yank<CR>
let g:coc_global_extensions = [
      \ 'coc-rls',
      \ 'coc-flutter',
      \ 'coc-html',
      \ 'coc-lists',
      \ 'coc-sh',
      \ 'coc-css',
      \ 'coc-go',
      \ 'coc-stylelintplus',
      \ 'coc-elixir',
      \ 'coc-solargraph',
      \ 'coc-word',
      \ 'coc-yaml',
      \ 'coc-highlight',
      \ 'coc-ultisnips',
      \ 'coc-snippets',
      \ 'coc-pairs',
      \ 'coc-diagnostic',
      \ 'coc-rls',
      \ 'coc-eslint',
      \ 'coc-prettier',
      \ 'coc-pyright',
      \ 'coc-docker',
      \ 'coc-jest',
      \ 'coc-tsserver',
      \ 'coc-xml',
      \]

call plug#end()

let mapleader = "\<Space>"

let test#strategy = "dispatch"
let test#javasctipt#runner = "jest"
let test#python#pytest#options = '--reuse-db'

nnoremap <silent> <Leader>tf :TestFile<CR>
nnoremap <silent> <Leader>tn :TestNearest<CR>
nnoremap <silent> <Leader>ts :TestSuite<CR>
nnoremap <silent> <Leader>tl :TestLast<CR>
nnoremap <silent> <Leader>tv :TestVisit<CR>

let g:paredit_mode=1

" let g:dispatch_quickfix_height = 90
" :let g:session_autoload = 'yes'
" :let g:session_autosave = 'yes'

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" enhanced command completion
set wildmenu

set autoindent

" set visualbell
set completeopt=noinsert,menuone,noselect

set nowrap
set number
set hlsearch
set ignorecase
set smartcase

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set splitbelow
set splitright

if has('mouse')
  set mouse=a
endif

set cursorline

" Don't redraw while executing macros (good performance config)
set lazyredraw
set ttyfast

set shortmess+=at

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nowb
set noswapfile

" toggle paste mode
set pastetoggle=<F2>

" do incremental
set incsearch
" MAGIC LIVE SUBSTITUTE REPLACE SEARCH
set inccommand=nosplit

set cmdheight=1
set scrolloff=3
set showcmd       " display incomplete commands
set autowrite     " Automatically :write before running commands

syntax on
filetype plugin indent on

" THEME

" colorscheme jellybeans
" let g:jellybeans_background_color_256='NONE'
" let g:jellybeans_use_term_background_color = 1
" let g:airline_theme='badwolf'


" supress error during setup
silent! colorscheme material

" color dracula

let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  let myUndoDir = expand(vimDir . '/undodir')
  call system('mkdir ' . vimDir)
  call system('mkdir ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif

let g:javascript_plugin_flow = 0

let g:easytags_async = 1
let g:alchemist_iex_term_size = 15
let g:alchemist_iex_term_split = 'split'
let g:alchemist_tag_disable = 1

" Always wrap prefered length
let g:vimreason_extra_args_expr_reason = '"--print-width=100"'

augroup au_common
  au!

  au BufWritePost init.vim,.vimrc source %
  " au BufWritePost *.re,*.rei :ReasonPrettyPrint

  " Automatically removing all trailing whitespace
  au BufWritePre * :%s/\s\+$//e

  au BufRead,BufNewFile {.babelrc,.eslintrc} set ft=json
augroup END

" Clojure
augroup rainbow_lisp
  autocmd!
  autocmd FileType lisp,clojure,scheme RainbowParentheses
augroup END

" augroup filetype_detect
"   autocmd BufNewFile,BufRead *.pug setlocal filetype=pug
" augroup END

vmap <C-_> gc
nmap <C-_> gcc

" select all text
nmap <C-a> ggVG<CR>

" nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>s :w<CR>
nnoremap <Leader>w :w<CR>

" noremap <F3> :ALEFix<CR>
noremap <F5> :e<CR>
nmap <F8> :TagbarToggle<CR>

" vmap <Tab> >gv
" vmap <S-Tab> <gv
" nmap <Tab> >gv
" nmap <S-Tab> <gv

" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#buffer_idx_mode = 1
" nmap <leader>[ <Plug>AirlineSelectPrevTab
" nmap <leader>] <Plug>AirlineSelectNextTab

" Map ctrl-movement keys to window switching
" map <C-k> <C-w><Up>
" map <C-j> <C-w><Down>
" map <C-l> <C-w><Right>
" map <C-h> <C-w><Left>
" nnoremap <silent> <bs> <C-w><Left>

nmap <silent> // :nohlsearch<CR>
noremap ,hl :set hlsearch! hlsearch?<CR>

nmap <silent> cp "_ciw<C-R>"<Esc>

" disable ex mode
nnoremap Q <nop>

" set text wrapping toggles
nmap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>

nmap <leader><S-O> o<esc>kk<CR>

nnoremap Y y$

" search and replace
nnoremap <Leader>fr :%s///g<Left><Left>
vnoremap <Leader>fr "hy:%s/<C-r>h//gc<left><left><left>

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" Edit .vimrc
map <leader>vl :vsp $MYVIMRC<CR>

map <leader>vc :CocConfig<CR>


" LSP
" Required for operations modifying multiple buffers like rename.
set hidden

" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" CtrlSF
nmap <leader>gg <Plug>CtrlSFPrompt
vmap <leader>gg <Plug>CtrlSFVwordPath
let g:ctrlsf_auto_focus = { "at": "start" }

nmap <silent> [b :bp<CR>
nmap <silent> ]b :bn<CR>

" vim-rooter
let g:rooter_patterns = ['Makefile','Rakefile', 'mix.exs', '.git/']

nnoremap <silent> <Leader>b <cmd>lua require('fzf-lua').buffers()<CR>
nnoremap <silent> <Leader>T <cmd>lua require('fzf-lua').btsgs()<CR>
nnoremap <silent> <Leader>t <cmd>lua require('fzf-lua').tags()<CR>
nnoremap <silent> <Leader>h <cmd>lua require('fzf-lua').oldfiles()<CR>
nnoremap <silent> <Leader>o <cmd>lua require('fzf-lua').git_files()<CR>
nnoremap <silent> <C-p> <cmd>lua require('fzf-lua').files()<CR>
nnoremap <Leader>ft <cmd>lua require('fzf-lua').filetypes()<CR>

nnoremap <silent> <Leader>/ <cmd>lua require('fzf-lua').grep_project()<CR>
vnoremap <leader>/  <cmd>lua require('fzf-lua').grep_visual()<CR>
vnoremap <leader>k  <cmd>lua require('fzf-lua').grep_cword()<CR>

nmap <leader>mp <Plug>MarkdownPreview
nmap <leader>ms <Plug>MarkdownPreviewStop
nmap <leader>mt <Plug>MarkdownPreviewToggle

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --fixed-strings --smart-case --hidden --follow --glob '!.git/*' ".shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Clipboard
" nmap <Leader>p :set paste<CR><esc>"+p: set nopaste<cr>
" nmap <Leader>P :set paste<CR><esc>o<Esc>"+p: set nopaste<cr>
" vmap <Leader>y "+y
" nnoremap Y y$

" Git fugitive
nnoremap <silent> <Leader>gl :Commits<CR>
nnoremap <silent> <Leader>ga :BCommits<CR>
nnoremap <silent> <Leader>gb :Git blame<CR>
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gvdiffsplit!<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

nmap <Leader>pr :call pry#insert()<CR>

" rails
nnoremap <silent> <Leader>e :A<CR>
nnoremap <silent> <Leader>r :R<CR>

map \e :%Eval<cr>
vmap \f :CljfmtRange<cr>

let g:clj_fmt_autosave = 0

nmap <C-i> :NERDTreeFind<CR>
nmap <silent> <leader><leader> :NERDTreeToggle<CR>

let NERDTreeIgnore = ['\.pyc$']
let g:nerdtree_tabs_open_on_console_startup = 1
let NERDTreeMapJumpNextSibling='<C-N>'
let NERDTreeMapJumpPrevSibling='<C-O>'

let g:loaded_netrwPlugin = 1

" COC
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
" set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
" set shortmess+=c

" always show signcolumns
set signcolumn=yes

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" slim
autocmd BufNewFile,BufRead *.slim setlocal filetype=slim
autocmd BufNewFile,BufRead *.slime setlocal filetype=slim
autocmd BufNewFile,BufRead *.slimleex setlocal filetype=slim

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

nnoremap <Leader>l :Format<CR>
nnoremap <Leader>i :CocCommand python.sortImports<CR>

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

call coc#config('python', {'pythonPath': $PYENV_VIRTUAL_ENV})
