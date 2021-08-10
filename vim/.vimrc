syntax enable
"set background=dark
"colorscheme stellarized

" indentation for python
au BufNewFile,BufRead *.py
  \ set tabstop=4 |
  \ set softtabstop=4 |
  \ set shiftwidth=4 |
  \ set textwidth=79 |
  \ set expandtab |
  \ set autoindent |
  \ set fileformat=unix

" indentation for yaml, json, js, html & css, xml, clojure
au BufNewFile,BufRead *.js,*.html,*.css,*.yml,*.json,*.xml,*.clj
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab

" indentation for Makefile
autocmd FileType make setlocal noexpandtab

" Avoid auto-indent when copy/pasting to Vim
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" Allow buffers to be hidden
set hidden
