#!/bin/sh
# abstract: generate tags for vim
# set tags=./tags,tags,~/dev/tags,~/dev/askas/utils-askas/vim/tags

# " go to tag definition and go back
# nnoremap <backspace> <C-]>
# nnoremap <tab>       <C-T>

ctags -f ~/dev/tags --recurse --totals \
  --exclude=blib --exclude=.svn  --exclude=CLEAN             \
  --exclude=.git --exclude='*~'                              \
  --extras=q                                                 \
  --languages=Perl,Vim                                       \
  --langmap=Perl:+.t                                         \
  ~/dev/

