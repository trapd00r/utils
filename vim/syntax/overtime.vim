" Vim syntax file
" Language: overtime
"   Author: Magnus Woldrich <m@japh.se>
"  Updated: 2011-09-06 15:08:22

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match otPrePeriod '\v^='                     skipwhite nextgroup=otPeriod
syn match otPeriod    '\v([A-Z]+)'               skipwhite
syn match otDate      '\v^([-0-9]+)|[0-9/]+'     skipwhite nextgroup=otHourCount
syn match otHourCount '\v\s+[0-9.]+'             skipwhite nextgroup=otWhat
syn match otWhat      '\v .+'                    skipwhite
syn match otIllness   '\v(SICK|SJUK)'            skipwhite

syn match otRange     '\v^[-0-9]+\s*»\s*[-0-9]+' skipwhite
syn match otComment   '\v#.*'                    skipwhite
syn match otHCTotal   '\v^Totalt?:.+'       skipwhite


hi      otDate      ctermfg=086 ctermbg=234 cterm=none
hi      otRange     ctermfg=240 ctermbg=234 cterm=bold
hi      otPeriod    ctermfg=118 ctermbg=235 cterm=none
hi      otPrePeriod ctermfg=196 ctermbg=237 cterm=bold
hi      otHCTotal   ctermfg=196 ctermbg=234 cterm=bold

hi link otComment   Comment
hi link otIllness   Conditional
hi link otDate      Title
hi link otHourCount Number
hi link otWhat      String

let b:current_syntax = "overtime"
