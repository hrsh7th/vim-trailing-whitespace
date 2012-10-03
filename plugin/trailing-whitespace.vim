let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_trailing_whitespace')
  finish
endif
let g:loaded_trailing_whitespace = 1

let g:trailing_whitespace_fix_events = get(g:, 'trailing_whitespace_fix_events', {
      \ 'BufWritePost': 0,
      \ 'BufWinEnter' : 0,
      \ 'InsertEnter' : 0,
      \ 'InsertLeave' : 0,
      \ })
let g:trailing_whitespace_highlight_events = get(g:, 'trailing_whitespace_highlight_events', {
      \ 'BufWritePost': 0,
      \ 'BufWinEnter' : 0,
      \ 'InsertEnter' : 0,
      \ 'InsertLeave' : 0,
      \ })

highlight TrailingWhitespace ctermbg=darkred guibg=#382424
autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red

for event in items(g:trailing_whitespace_fix_events)
  if event[1]
    execute 'autocmd ' . event[0] . ' * call' . "<SID>" . 'FixWhitespace(0, line("$"))'
  endif
endfor

for event in items(g:trailing_whitespace_highlight_events)
  if event[1]
    execute 'autocmd ' . event[0] . ' * match TrailingWhitespace /\s\+$/'
  endif
endfor

function! s:FixWhitespace(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\s\+$//'
    call setpos('.', l:save_cursor)
endfunction

command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)

let &cpo = s:save_cpo
unlet s:save_cpo

