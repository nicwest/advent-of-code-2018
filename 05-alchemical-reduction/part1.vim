" vim: set ft=vim ts=2 sw=2 tw=78 et fdm=marker:

let s:a = map(range(char2nr('a'), char2nr('z')), 'nr2char(v:val)')
let s:A = map(range(char2nr('A'), char2nr('Z')), 'nr2char(v:val)')

let s:pattern = '\C\(' . join(map(range(26), "s:a[v:val] . s:A[v:val] . '\\|' . s:A[v:val] . s:a[v:val]"), '\|') . '\)'

function s:collapse() abort
  let l:line = getline('.')
  exec 's/' . s:pattern .'//'
  return l:line !=# getline('.')
endfunction

edit input.txt

let s:i = 1
while(s:collapse())
  let s:i += 1
endwhile

echom 'iterations: '.s:i
echom 'length: '. len(getline('.'))
