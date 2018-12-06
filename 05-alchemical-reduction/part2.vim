" vim: set ft=vim ts=2 sw=2 tw=78 et fdm=marker:

function! s:collapse(left, a, b, right) abort
  if a:a ==? a:b && a:a !=# a:b
    return [a:left[:-2], a:left[-1:-1], a:right[0], a:right[1:]]
  endif
  return [a:left . a:a, a:b, a:right[0], a:right[1:]]
endfunction

function! Collapse() abort
  let l:right = getline('.')
  let l:left = ''
  let l:a = ''
  let l:b = ''
  while(len(l:right))
    let [l:left, l:a, l:b, l:right] = s:collapse(l:left, l:a, l:b, l:right)
  endwhile
  exec 'norm! cc' . len(l:left)
endfunction

function! GenVariations() abort
  norm! yy26pgg
  for l:ch in range(char2nr('a'), char2nr('z'))
    exec 's/\c'.nr2char(l:ch).'//'
    norm! j
  endfor
endfunction
