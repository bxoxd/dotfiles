" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" use minpac to manage plugins
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', { 'type': 'opt'})
call minpac#add('tpope/vim-unimpaired')

set guifont=Consolas:h16
set lines=24 columns=80
winpos 700 150
colorscheme slate

" The directory must exist, Vim will not create it for you.
" the dir name ending in two path separators will cause the filename
" to be built from the complete path to the file
if has('persistent_undo')
    let &undodir = expand("$HOME") . '/.vimtemp/undo//'
    if !isdirectory(&undodir)
        call mkdir(&undodir, "p")
    endif
    set undofile
endif

let &backupdir = expand("~/.vimtemp/backup//")
if !isdirectory(&backupdir)
	call mkdir(&backupdir, "p")
endif
set backup

let &directory = expand("~/.vimtemp/swap//")
if !isdirectory(&directory)
	call mkdir(&directory, "p")
endif

set number
set hlsearch
set incsearch
