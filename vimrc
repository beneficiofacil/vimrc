"==============================================================================
" Updated vimrc based on the Nitrous.IO vimrc for
" the new docker-based Nitrous Pro version.

"------------------------------------------------------------------------------
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"------------------------------------------------------------------------------
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/bufkill.vim'

Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'vim-scripts/Rename2'

Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Lokaltog/vim-powerline'

Plugin 'tpope/vim-git'
Plugin 'fatih/vim-go'

Plugin 'pangloss/vim-javascript'
Plugin 'othree/html5.vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'tpope/vim-markdown'
Plugin 'timcharper/textile.vim'
Plugin 'vim-scripts/csv.vim'
Plugin 'snipMate'
Plugin 'https://bitbucket.org/ronoaldo/custom-vim-snippets'
Plugin 'Blackrush/vim-gocode'
Plugin 'tpope/vim-surround'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'velocity.vim'
Plugin 'majutsushi/tagbar'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'kchmck/vim-coffee-script'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"------------------------------------------------------------------------------
" basic
"
set number
set ruler          " show line and column number
syntax enable
set encoding=utf-8
set visualbell     " shut vim up
set noerrorbells
set history=1000
set autoread

"------------------------------------------------------------------------------
" editing
"
set showmatch      " Show matching brackets
"set matchtime=5    " bracket blinking
set showcmd        " show incomplete commands in lower right hand corner
set showmode
set hidden         " current buffer can be put to the background without writing to disk

" folds
set foldmethod=indent
set foldnestmax=3
set nofoldenable

"------------------------------------------------------------------------------
" searching
"
set hlsearch   " highlight searches
set incsearch  " incremental searching
set ignorecase " searches are case insensitive
set smartcase  " unless there is one capital letter

" scrolling
set scrolloff=5
set sidescrolloff=5
set sidescroll=1

"------------------------------------------------------------------------------
" wild
"
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.out,*.obj,*.class
set wildignore+=*.swp,*~,._*
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=.git,.svn
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=*/vendor/assets/**
set wildignore+=*/vendor/rails/**
set wildignore+=*/vendor/cache/**
set wildignore+=*/vendor/bundle/**
set wildignore+=*/vendor/submodules/**
set wildignore+=*/vendor/plugins/**
set wildignore+=*/vendor/gems/**
set wildignore+=*/.bundle/**
set wildignore+=*.gem
set wildignore+=*/log/**
set wildignore+=*/tmp/**
set wildignore+=*/_vendor/**

"------------------------------------------------------------------------------
" backup & swap
"
set noswapfile
set nobackup
set nowb

"persistent undo
"silent !mkdir ~/.vim/backups > /dev/null 2>&1
"set undodir=~/.vim/backups
"set undofile

"colorscheme
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_visibility="high"
set background=dark
silent! colorscheme solarized

"------------------------------------------------------------------------------
" filetypes
" https://raw.github.com/carlhuda/janus/master/janus/vim/core/before/plugin/filetypes.vim
"
function! s:setupWrapping()
  set wrap
  set linebreak
  set textwidth=72
  set nolist
endfunction

filetype plugin indent on " Turn on filetype plugins (:help filetype-plugin)

" Remember last location in file, but not for commit messages.
" see :help last-position-jump
au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g`\"" | endif

au BufNewFile,BufRead *.json set ft=javascript

"------------------------------------------------------------------------------
if has("statusline") && !&cp
  set laststatus=2
  set noequalalways
endif

"------------------------------------------------------------------------------
" other settings
"

" ack-vim
let g:ackprg="ag --nogroup --nocolor --column"

" https://github.com/carlhuda/janus/blob/master/janus/vim/tools/janus/after/plugin/syntastic.vim
let g:syntastic_enable_signs=1
let g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_auto_loc_list=2

""" nerdtree
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.rbc$', '\.rbo$', '\.class$', '\.o$', '\~$']
let NERDTreeHijackNetrw = 0

augroup AuNERDTreeCmd
autocmd AuNERDTreeCmd VimEnter * call s:CdIfDirectory(expand("<amatch>"))
autocmd AuNERDTreeCmd FocusGained * call s:UpdateNERDTree()

" If the parameter is a directory, cd into it
function s:CdIfDirectory(directory)
  let explicitDirectory = isdirectory(a:directory)
  let directory = explicitDirectory || empty(a:directory)

  if explicitDirectory
    exe "cd " . fnameescape(a:directory)
  endif

  " Allows reading from stdin
  " ex: git diff | mvim -R -
  if strlen(a:directory) == 0
    return
  endif

  if directory
    NERDTree
    wincmd p
    bd
  endif

  if explicitDirectory
    wincmd p
  endif
endfunction

" NERDTree utility function
function s:UpdateNERDTree(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists("t:NERDTreeBufName")
    let nr = bufwinnr(t:NERDTreeBufName)
    if nr != -1
      exe nr . "wincmd w"
      exe substitute(mapcheck("R"), "<CR>", "", "")
      if !stay
        wincmd p
      end
    endif
  endif
endfunction
"""""

" Default mapping, <leader>n
"autocmd VimEnter * silent! lcd %:p:h

"------------------------------------------------------------------------------
" mappings (kept to minimal)

map <C-c> <ESC>
"let mapleader=","

" much more natural cursor movement when wrapping lines are present
map j gj
map k gk
map <Down> gj
map <Up> gk

" ctrl-p
map <C-t> :CtrlP<CR>
imap <C-t> <ESC>:CtrlP<CR>
map <C-p> :CtrlP<CR>
imap <C-p> <ESC>:CtrlP<CR>

" unimpaired
" Bubble single lines
nmap <C-k> [e
nmap <C-j> ]e

" Bubble multiple lines
vmap <C-k> [egv
vmap <C-j> ]egv

" nerd tree
map <leader>n :NERDTreeToggle<CR>

" nerd commenter
map <leader>/ <plug>NERDCommenterToggle<CR>

" Tab helper functions
fu! SetupNormalTabs()
  setlocal sw=4 ts=4 st=4 noet si ai
endfu

fu! SetupSpaceTabs()
  setlocal sw=4 ts=4 st=4 et si ai
endfu

fu! Setup2SpaceTabs()
  setlocal sw=2 ts=2 st=2 et si ai
endfu

" Message helper
fu! Info(msg)
  execute "echom '[ " . a:msg . " ]'"
endfu

" All-modes shortcut helper function
fu! KeyMap(key, action, insert_mode)
  execute "noremap  <silent> " . a:key . " " . a:action . "<CR>"
  execute "vnoremap <silent> " . a:key . " <C-C>" . a:action . "<CR>"
  if a:insert_mode
    execute "inoremap <silent> " . a:key . " <C-O>" . a:action . "<CR>"
  endif
endfu

" Disposable temporary window
fu! TempWindow(name, clear, mode) abort
  let name = substitute(a:name, "[^a-zA-Z0-9]", "_", "g")
  let bn = bufnr(name)
  if bn == -1
    exe "new " . name
    let bn = bufnr(name)
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal buflisted
  else
    let wn = bufwinnr(bn)
    if wn != -1
      exe wn . "wincmd w"
    else
      exe "split +buffer" . bn
    endif
  endif

  if a:clear
    normal gg
    normal dG
  endif
  if a:mode == 'v'
    wincmd L
  else
    wincmd J
  endif
endfu

" Mercurial helper functions
fu! HgPull()
  call Info("Pulling changes from remote repository ...")
  !hg pull
endfu

fu! HgPush()
  call Info("Pushing changes to remote repository ...")
  !hg push
endfu

fu! HgDiff()
  call TempWindow("Mercurial Changes", 1, 'v')
  setfiletype diff
  execute 'silent r!hg diff --git'
  0d
endfu

fu! HgMergeMsg()
  execute "silent r!echo -n 'Merge with '; hg id -i | cut -f 2 -d'+'"
  0d
endfu

fu! Hg(...)
  call TempWindow('Mercurial', 1, 'h')
  let hg_cmd = 'silent r!hg '
  for s in a:000
    let hg_cmd = hg_cmd . ' ' . s
  endfor
  execute hg_cmd
  0d
endfu

" Maven
fu! Mvn(...)
  let mvn_cmd = 'silent r!mvn '
  for s in a:000
    let mvn_cmd = mvn_cmd . ' ' . s
  endfor
  call TempWindow('Maven', 1, 'h')
  echo "Running " . mvn_cmd
  execute mvn_cmd
  setlocal filetype=mvnbuild
  0d
endfu

fu! MavenDebug(port)
  call Info("Starting jdb ... ")
  let jdb = "!jdb -sourcepath " . $PWD . "/src/main/java:" . $PWD . "/src/test/java"
  let jdb = jdb . " -port " . a:port
  execute jdb
endfu

fu! MavenWorkspace()
  let l:pom = findfile("pom.xml", ";")
  if filereadable(l:pom)
    let g:maven_project=1
    setlocal tags=./.tags;
  endif
endfu

fu! MavenCtags()
  call Info("Atualizando tags em sua workspace ...")
  let ctags = "!rm -vf " . g:default_java_workspace . "/.tags &&"
  let ctags = ctags . " find " . g:default_java_workspace . " -type f -iname '*.java' |"
  let ctags = ctags . " xargs ctags -a -f ". g:default_java_workspace . "/.tags"
  let ctags = ctags . " --exclude='*/target/*'  -L - --totals"
  execute ctags

  setlocal tags=./.tags;
  echo "Tag path: " . &tags
endfu

" CTags
fu! Ctags()
  call Info("Indexing current directory ...")
  let ctags = "!rm -vf ./.tags && find ./ -type f |"
  let ctags = ctags . " xargs ctags -a -f ./.tags "
  let ctags = ctags . " --exclude='*/target/*' --exclude='*min.js'"
  let ctags = ctags . " -L - --totals"
  execute ctags

  setlocal tags=./.tags;
  echo "Tag path " . &tags
endfu

" Google App Engine Go
function! GoappTest()
  let test_line = search("func Test", "bs")
  ''
  if test_line > 0
    let line = getline(test_line)
    let test_name_raw = split(line, " ")[1]
    let test_name = split(test_name_raw, "(")[0]
    let go_cmd = '!goapp test -v -test.run=' . test_name
    exec go_cmd
  else
    echo "No test found"
  endif
endfunction

" From http://vim.wikia.com/wiki/Find_files_in_subdirectories
" Find file in current directory and edit it.
function! Find(name)
  let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":split ".l:line
endfunction

function! FormatJSON()
  %!python -m json.tool
endfunction

" Default options for various file types
augroup filemapping
  " Velocity file types
  au BufRead,BufNewFile *.vm setlocal filetype=velocity
  " Java settings  
  au BufRead,BufNewFile *.java compiler javac
  au BufRead,BufNewFile *.java setlocal makeprg=javac\ %
  au BufRead,BufNewFile *.java let g:syntastic_java_javac_options = "-Xlint -encoding utf-8"
  au BufRead,BufNewFile *.bsh setlocal filetype=java
  " Go AppEngine support via 'goapp'
  if executable('goapp')
    au BufRead,BufNewFile *.go setlocal makeprg=goapp\ test\ -c
    au BufRead,BufNewFile *.go let g:syntastic_go_checkers=['goapp', 'govet', 'golint']
  else
    au BufRead,BufNewFile *.go setlocal makeprg=go\ test\ -c
    au BufRead,BufNewFile *.go let g:syntastic_go_checkers=['go', 'govet', 'golint']
  end

  " Conveniencia para revisar o diff antes do commit
  au BufRead /tmp/hg-editor-* call HgDiff()

  " Auto close preview/scratch window after select option with omnicomplete
  autocmd CursorMovedI * if pumvisible() == 0 | pclose | endif
  autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

  " Posiciona a janela QuickFix sempre na parte inferior da tela
  au FileType qf wincmd J
augroup END

" Java/Maven workspace setup
let g:default_java_workspace="~/workspace"
augroup workspace
  au!
  let s:workspace_init = 1
  autocmd VimEnter * call MavenWorkspace()
  autocmd FileType java TagbarOpen
augroup END

" Mercurial
command! -nargs=+ Hg call Hg("<args>")

" Ctags
command! Ctags call Ctags()

" Maven
command! -nargs=+ Mvn call Mvn("<args>")
command! MavenCtags   call MavenCtags()
command! MavenBuild   :Mvn clean package
command! MavenTest    call Mvn("-o", "test", "-DskipTests=false", "-Dtest=".expand("%:t:r"), "-DfailIfNoTests=true")
command! MavenTestAll :Mvn -o test
command! MavenInstall :Mvn -o clean install
command! MavenClean   :Mvn -o clean
command! MavenDebug   call MavenDebug(5005)

" Golang
command! -nargs=* GoappTest call GoappTest()

" Find
command! -nargs=1 Find :call Find("<args>")

" Javascript/JSON
" Function to format json files usint python module
command! FormatJSON call FormatJSON()

" Keyboard and Shortcuts
let mapleader=","
" \s save
call KeyMap('<Leader>s', ':update', 0)
" \x close all
call KeyMap("<Leader>x", ":quitall", 0)
" \u pull changes
call KeyMap("<Leader>u", ":Hg pull", 0)
" \p push changes
call KeyMap("<Leader>p", ":Hg push", 0)
" \i mvn install
call KeyMap("<Leader>i", ":MavenInstall", 0)
" \b mvn clean package
call KeyMap("<Leader>b", ":MavenBuild", 0)
" \t mvn test
call KeyMap("<Leader>t", ":MavenTest", 0)
" Ctrl F11 open file tree
call KeyMap("<C-F11>", ":NERDTreeToggle", 1)
" Ctrl F10 open tag tree
call KeyMap("<C-F10>", ":TagbarToggle", 1)
" Ctrl Shift F format code
call KeyMap("<C-S-F>", ":normal gg=G", 1)
" \f format code
call KeyMap("<Leader>f", ":normal gg=G", 0)
" \w change window
call KeyMap("<Leader>w", ":wincmd W", 0)
" \+ increase window vertical size
call KeyMap("<Leader>+", ":exe \"vertical resize \" . (winheight(0) * 3/2)<CR>", 0)
" \- decrease window vertical size
call KeyMap("<Leader>-", ":exe \"vertical resize \" . (winheight(0) * 2/3)<CR>", 0)
" \t Run Goapp Tests
call KeyMap("<Leader>t", ":GoappTest", 0)
" \fj Format JSON file
call KeyMap("<Leader>fj", ":FormatJSON", 0)
" Omnicomplete
inoremap <Leader>, <C-X><C-O>
inoremap <C-Space> <C-X><C-O>
inoremap <C-@> <C-X><C-O>
" Move line/block up: \k
nnoremap <leader>k :m-2<cr>
vnoremap <leader>k :m'<-2<cr>gv=gv
" Move line/block down: \j
nnoremap <leader>j :m+1<cr>
vnoremap <leader>j :m'>+1<cr>gv=gv
" Duplicate line/block down: \y
nnoremap <leader>y :t.<cr>
vnoremap <leader>y :t'>.<cr>gv=gv
" Navigate by errors
call KeyMap("<leader>p", ":lprev", 0)
call KeyMap("<leader>n", ":lnext", 0)

" Goodies with Syntastic
let g:syntastic_full_redraws=1
let g:syntastic_auto_loc_list=0
