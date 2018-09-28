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

" indentation for yaml, json, js, html & css, xml
au BufNewFile,BufRead *.js,*.html,*.css,*.yml,*.json,*.xml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab

" indentation for Makefile
autocmd FileType make setlocal noexpandtab
